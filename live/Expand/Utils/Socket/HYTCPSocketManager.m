//
//  HYTCPSocketManager.m
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPSocketManager.h"
#import "HYTCPServer.h"
#import <GCDAsyncSocket.h>
#import "HYTCPSocketTask.h"
#import "HYTCPSocketHeartDetect.h"

@interface HYTCPSocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic,strong) HYTCPServer *TCPServer;
@property (nonatomic,strong) GCDAsyncSocket *socket;
@property (nonatomic,strong) dispatch_queue_t socketQueue;

@property (nonatomic,strong) NSThread *socketThread;
@property (nonatomic,strong) NSPort *machPort;
@property (nonatomic,assign) BOOL isKeepConnecting;
@property (nonatomic,assign) BOOL isConnecting;
@property (nonatomic,assign) BOOL isReading;                    //是否正在读取
@property (nonatomic,assign) NSInteger reconnectCount;          //重连次数
@property (nonatomic,strong) NSMutableData *bufferData;         //缓冲池
@property (nonatomic,strong) NSMutableDictionary<NSNumber *, HYTCPSocketTask *> *taskDictionary;
@property (nonatomic,strong) HYTCPSocketHeartDetect *heartDetect;

@end

static NSInteger socketTag = 10086;
static NSInteger socketHeartTag = 10010;
static HYTCPSocketManager *socketManager;
static dispatch_semaphore_t lock;            //信号量，用来加锁

@implementation HYTCPSocketManager

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lock = dispatch_semaphore_create(1);
        socketManager = [[HYTCPSocketManager alloc] initwithTCPServer:nil];
    });
    return socketManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [super allocWithZone:zone];
    });
    return socketManager;
}


#pragma mark - PrivatedMethod
- (instancetype)initwithTCPServer:(HYTCPServer *)TCPServer{
    
    if (self == [super init]) {
        
        TCPServer = TCPServer ?: [HYTCPServer defaultServer];
        self.TCPServer = TCPServer;
        [self _initData];
        [self _initGCDSocket];
        //创建线程，开启runloop
        [NSThread detachNewThreadSelector:@selector(_configSocketThread) toTarget:self withObject:nil];
        __weak typeof(self) weakSelf = self;
        self.heartDetect = [HYTCPSocketHeartDetect heartDetectWithSocketManager:self timeoutHandler:^{
            DLog(@"socket连接不通了，正在断开socket");
            [weakSelf _disconnect];
            [weakSelf.heartDetect stop];
        }];
    }
    return self;
}

- (void)_initGCDSocket{
    
    _socketQueue = dispatch_queue_create("socket_queue", DISPATCH_QUEUE_SERIAL);
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    _socket.IPv4PreferredOverIPv6 = YES;
    _isKeepConnecting = YES;
}

- (void)_initData{
    
    _bufferData = [NSMutableData data];
    _taskDictionary = [NSMutableDictionary dictionary];
    self.maxRetryReconnectCount = _maxRetryReconnectCount ?: 5;
}

- (void)_configSocketThread{
    
    if (!_socketThread) {
        //如果线程不存在，就创建线程
        _socketThread = [NSThread currentThread];
        _machPort = [NSMachPort port];
        [[NSRunLoop currentRunLoop] addPort:self.machPort forMode:NSDefaultRunLoopMode];
    }
    
    while (_isKeepConnecting) {
        //等待消息处理  socket线程会一直等待 不会执行下面的代码
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    [[NSRunLoop currentRunLoop] removePort:self.machPort forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
    [self.socketThread cancel];
    self.socket = nil;
    self.machPort = nil;
    self.socketThread = nil;
    self.socketQueue = nil;
}

- (void)_disconnect{
    
    if (!self.socket.isConnected) return;
    [self.socket setDelegate:nil delegateQueue:nil];
    [self.socket disconnect];
    
    
    [self cancelAllSocketTasks];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.taskDictionary removeAllObjects];
    dispatch_semaphore_signal(lock);
    
}

- (void)_connectOnSocketThread{
    
    [self.socket setDelegate:self delegateQueue:self.socketQueue];
    NSError *connectError;
    [self.socket connectToHost:[_TCPServer host] onPort:[_TCPServer port] error:&connectError];
    _isConnecting = NO;
}

- (void)_tryReconnect{
    
    if (_isConnecting) return;
    _reconnectCount += 1;
    //如果重连次数小于最大重连次数,就重连
    if (_reconnectCount < _maxRetryReconnectCount) {
        [self connect];
    }
}

#pragma mark - PublicMethod
- (void)connect{
    
    if (_isConnecting) return;
    _isConnecting = YES;
    DLog(@"socket开始连接");
    //连接前先取消连接
    [self _disconnect];
    [self _connectOnSocketThread];
    
}

- (void)close{
    
    _isConnecting = NO;
    _isKeepConnecting = NO;
    [self _disconnect];
    [self performSelector:@selector(_configSocketThread) onThread:_socketThread withObject:nil waitUntilDone:YES];
}

- (void)reconnect{
    
    //将自动重连次数置空
    self.reconnectCount = 0;
    [self connect];
}

- (void)writeData:(NSData *)data{
    
    if (data.length <= 0) return;
    [self.socket writeData:data withTimeout:-1 tag:socketTag];
}

- (BOOL)isConnect{
    return self.socket.isConnected;
}

- (NSInteger)maxRetryReconnectCount{
    return _maxRetryReconnectCount ? _maxRetryReconnectCount : 5;
}

- (uint32_t)startSocketTask:(HYTCPSocketRequest *)request complection:(void (^)(NSDictionary *, NSError *))complection{
    
    HYTCPSocketTask *task = [HYTCPSocketTask taskWithRequest:request complection:complection];
    if (!task)  return -1;
    [task resume];
    [self.taskDictionary setObject:task forKey:@(task.taskIdentifier)];
    return task.taskIdentifier;
}

- (void)cancelSocketTaskWithIdentifier:(uint32_t)taskIdentifier{
    
    HYTCPSocketTask *task = self.taskDictionary[@(taskIdentifier)];
    [task cancelTask];
}

- (void)cancelAllSocketTasks{
    
    [[self.taskDictionary allValues] makeObjectsPerformSelector:@selector(cancelTask)];
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [_taskDictionary removeAllObjects];
    dispatch_semaphore_signal(lock);
    
}

- (void)resumeTask:(HYTCPSocketTask *)task{
    
    if (self.isConnect) {
        NSData *requestData = [task.request requestData];
        [self.socket writeData:requestData withTimeout:-1 tag:socketHeartTag];
    }
}

#pragma mark - ParseData
- (void)readData{
    
    if (_isReading) return;
    _isReading = YES;
    NSData *responseData = [self _getResponseData];
    [self _handleResponseData:responseData];
    _isReading = NO;
    
    if (responseData.length <= 0) return;
    [self readData];
    
}

- (NSData *)_getResponseData{
    
    NSData *receiveTotalData = self.bufferData;
    uint32_t dataHeaderLength = [HYTCPDataParse responseHeaderLength];
    if (self.bufferData.length < dataHeaderLength) return nil;
    uint32_t responseContentLength = [HYTCPDataParse responseContentLengthFromData:self.bufferData];
    uint32_t responseLength = dataHeaderLength + responseContentLength;
    //接收的数据不是完整的
    if (receiveTotalData.length < responseLength) return nil;
    NSData *responseData = [receiveTotalData subdataWithRange:NSMakeRange(0, responseLength)];
    self.bufferData = [[self.bufferData subdataWithRange:NSMakeRange(responseLength, receiveTotalData.length - responseLength)] mutableCopy];
    return responseData;
}

- (void)_handleResponseData:(NSData *)responseData{
    
    HYTCPSocketResponse *response = [HYTCPSocketResponse responseWithData:responseData];
    if (response.requestUrl == TCPSocketRequestTypeHeart) {
        [self.heartDetect handlerServerAck:response.serialNum];
    }
    else if (response.requestUrl == TCPSocketRequestTypeNotification){
        
    }
}

#pragma mark - GCDSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    DLog(@"socket连接成功了");
    self.reconnectCount = 0;
    [self.socket readDataWithTimeout:-1 tag:socketTag];
    [self.heartDetect reset];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    DLog(@"socket连接失败了:%@",err.description);
    [self _tryReconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    [self.socket readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    [self.socket readDataWithTimeout:-1 tag:tag];
    [self.bufferData appendData:data];
    [self readData];
    [self.heartDetect reset];
}

@end
