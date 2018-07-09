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

@end

static NSInteger socketTag = 10086;
static HYTCPSocketManager *socketManager;


@implementation HYTCPSocketManager

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
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
        self.maxRetryReconnectCount = _maxRetryReconnectCount ?: 5;
        [self _initGCDSocket];
        //创建线程，开启runloop
        [NSThread detachNewThreadSelector:@selector(_configSocketThread) toTarget:self withObject:nil];
        [self _initData];
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

#pragma mark - ParseData
- (void)readData{
    
    if (_isReading) return;
    _isReading = YES;
    
}

#pragma mark - GCDSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    DLog(@"socket连接成功了");
    self.reconnectCount = 0;
    [self.socket readDataWithTimeout:-1 tag:socketTag];
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
}

@end
