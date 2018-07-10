//
//  HYTCPSocketHeartDetect.m
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPSocketHeartDetect.h"

@interface HYTCPSocketHeartDetect ()

@property (nonatomic,strong) HYTCPSocketManager *socketManager;
@property (nonatomic,strong) void(^timeoutHandler)(void);
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger heartMissCount;

@end

static NSInteger maxMissCount = 3;      //最大丢失次数

@implementation HYTCPSocketHeartDetect

+ (instancetype)heartDetectWithSocketManager:(HYTCPSocketManager *)socketManager timeoutHandler:(void (^)(void))timeoutHandler{
    
    HYTCPSocketHeartDetect *heartDetect = [[HYTCPSocketHeartDetect alloc] init];
    heartDetect.socketManager = socketManager;
    heartDetect.timeoutHandler = timeoutHandler;
    [heartDetect _start];
    return heartDetect;
}

- (void)_start{
    
    [self stop];
    _timer = [NSTimer timerWithTimeInterval:TCPSocketHeartDetectInterval target:self selector:@selector(_sendHeartDetectPackage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)_sendHeartDetectPackage{
    
    _heartMissCount += 1;
    if (_heartMissCount >= maxMissCount && self.timeoutHandler) {
        self.timeoutHandler();
        self.heartMissCount = -1;
    }
    
    //发送心跳包
    HYTCPSocketRequest *request = [HYTCPSocketRequest requestWithUrl:TCPSocketRequestTypeHeart parameters:@{TCPHeartDetectAckKey : @(TCPSocketRequestTypeHeart)} header:nil];
    [self.socketManager startSocketTask:request complection:nil];
}

- (void)reset{

    _heartMissCount = -1;
    [self _start];
}

- (void)stop{
    
    [_timer invalidate];
}

- (void)handlerServerAck:(uint32_t)serverAckNum{
    
    DLog(@"收到:ack:%d",serverAckNum);
    if (serverAckNum == TCPSocketRequestTypeHeart) {
        self.heartMissCount = -1;
        return;
    }
    [self _sendHeartDetectPackage];
}

@end
