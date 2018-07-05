//
//  HYTCPSocketManager.h
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYTCPSocketManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign) NSInteger maxRetryReconnectCount;  //最大重连次数

- (void)connect;
- (void)close;
- (void)reconnect;
- (BOOL)isConnect;

@end
