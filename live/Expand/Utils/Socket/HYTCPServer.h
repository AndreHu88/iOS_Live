//
//  HYTCPServer.h
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYTCPServerDelegate <NSObject>

@optional
- (int16_t)testEnvironmentPort;
- (NSString *)testEnvironmentHost;

- (int16_t)developEnvironmentPort;
- (NSString *)developEnvironmentHost;

- (int16_t)releaseEnvironmentPort;
- (NSString *)releaseEnvironmentHost;

@end

@interface HYTCPServer : NSObject <HYTCPServerDelegate>

+ (instancetype)defaultServer;

- (NSString *)host;

- (uint16_t)port;

@end
