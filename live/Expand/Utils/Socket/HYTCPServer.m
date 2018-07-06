//
//  HYTCPServer.m
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPServer.h"
#import "HYSocketConfig.h"

@interface HYTCPServer ()

@property (nonatomic,assign) HYTCPServerType type;
@property (nonatomic,assign) HYTCPServerEnvironment environment;

@end

@interface HYTCPServerShangHai : HYTCPServer


@end


@implementation HYTCPServerShangHai

- (NSString *)testEnvironmentHost{
    return @"localhost";
}

- (int16_t)testEnvironmentPort{
    return 23456;
}

- (NSString *)developEnvironmentHost{
    return @"localhost";
}

- (int16_t)developEnvironmentPort{
    return 23456;
}

- (NSString *)releaseEnvironmentHost{
    return @"localhost";
}

- (int16_t)releaseEnvironmentPort{
    return 23456;
}

@end

@interface HYTCPServerGuangDong : HYTCPServer

@end


@implementation HYTCPServerGuangDong

- (NSString *)testEnvironmentHost{
    return @"localhost";
}

- (int16_t)testEnvironmentPort{
    return 23456;
}

- (NSString *)developEnvironmentHost{
    return @"localhost";
}

- (int16_t)developEnvironmentPort{
    return 23456;
}

- (NSString *)releaseEnvironmentHost{
    return @"localhost";
}

- (int16_t)releaseEnvironmentPort{
    return 23456;
}

@end

@interface HYTCPServerHK : HYTCPServer


@end


@implementation HYTCPServerHK

- (NSString *)testEnvironmentHost{
    return @"localhost";
}

- (int16_t)testEnvironmentPort{
    return 23456;
}

- (NSString *)developEnvironmentHost{
    return @"localhost";
}

- (int16_t)developEnvironmentPort{
    return 23456;
}

- (NSString *)releaseEnvironmentHost{
    return @"localhost";
}

- (int16_t)releaseEnvironmentPort{
    return 23456;
}

@end


@implementation HYTCPServer


+ (instancetype)defaultServer{
    
    return [self serverWithType:HYTCPServerTypeShangHai];
}

+ (HYTCPServer *)serverWithType:(HYTCPServerType)serverType{
    
    HYTCPServer *tcpServer;
    switch (serverType) {
        case HYTCPServerTypeShangHai:
            tcpServer = [HYTCPServerShangHai new];
            break;
        case HYTCPServerTypeGuangZhou:
            tcpServer = [HYTCPServerGuangDong new];
            break;
        case HYTCPServerTypeHK:
            tcpServer = [HYTCPServerHK new];
            break;
        default:
            break;
    }
    tcpServer.type = serverType;
    tcpServer.environment = HYTCPServerEnvironmentTest;
    return tcpServer;
}

- (NSString *)host{
    
    switch (self.environment) {
        case HYTCPServerEnvironmentTest:
            return [self testEnvironmentHost];
            break;
        case HYTCPServerEnvironmentDevelop:
            return [self developEnvironmentHost];
            break;
        case HYTCPServerEnvironmentRelease:
            return [self releaseEnvironmentHost];
            break;
        default:
            break;
    }
}

- (uint16_t)port{
    
    switch (self.environment) {
        case HYTCPServerEnvironmentTest:
            return [self testEnvironmentPort];
            break;
        case HYTCPServerEnvironmentDevelop:
            return [self developEnvironmentPort];
            break;
        case HYTCPServerEnvironmentRelease:
            return [self releaseEnvironmentPort];
            break;
        default:
            break;
    }
}

@end
