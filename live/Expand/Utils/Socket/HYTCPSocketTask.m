//
//  HYTCPSocketTask.m
//  live
//
//  Created by Duntech on 2018/7/10.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPSocketTask.h"

@interface HYTCPSocketTask ()

@property (nonatomic,assign) TCPSocketTaskState state;
@property (nonatomic,strong) void(^(complectionBlock))(NSDictionary *result, NSError *error);
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation HYTCPSocketTask

+ (instancetype)taskWithRequest:(HYTCPSocketRequest *)request complection:(void (^)(NSDictionary *, NSError *))complectionHandler{
    
    HYTCPSocketTask *task = [HYTCPSocketTask new];
    task.complectionBlock = complectionHandler;
    task.state = TCPSocketTaskStateSuspend;
    task.request = request;
    return task;
}

#pragma mark - PublicMethod
- (void)resume{
    
    if (self.state != TCPSocketTaskStateSuspend) return;
    self.timer = [NSTimer timerWithTimeInterval:self.request.requestTimeOutInterval target:self selector:@selector(_requestTimeOut) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    self.state = TCPSocketTaskStateRunning;
    [[HYTCPSocketManager shareInstance] resumeTask:self];
}


- (void)cancelTask{
    
    if (self.state == TCPSocketTaskStateCancel) return;
    self.state = TCPSocketTaskStateCancel;
    [self _complectWithResult:nil error:[self _errorWithResponseCode:TCPSocketTaskErrorCanceled]];
    
}

- (uint32_t)taskIdentifier{
    
    return self.request.requestIdentifier;
}

#pragma mark - uitls
- (void)_complectWithResult:(NSDictionary *)result error:(NSError *)error{
    
    self.state = (self.state > TCPSocketTaskStateCancel) ?: TCPSocketTaskStateComplection;
    [self.timer invalidate];
    dispatch_async_on_main_queue(^{
        
        !self.complectionBlock ?: self.complectionBlock(result,error);
        self.complectionBlock = nil;
        
    });
}

- (NSError *)_errorWithResponseCode:(TCPSocketTaskError)errorCode{
    
    NSError *error = [NSError errorWithDomain:@"" code:errorCode userInfo:nil];
    return error;
}

- (void)_requestTimeOut{
    
    if (self.state >= TCPSocketTaskStateRunning) return;
    self.state = TCPSocketTaskStateCancel;
    [self _complectWithResult:nil error:[self _errorWithResponseCode:TCPSocketTaskErrorTimeOut]];
}


@end
