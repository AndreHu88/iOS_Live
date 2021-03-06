//
//  HYTCPSocketManager.h
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTCPSocketResponse.h"
#import "HYTCPSocketTask.h"

@interface HYTCPSocketManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign) NSInteger maxRetryReconnectCount;  //最大重连次数

- (void)connect;
- (void)close;
- (void)reconnect;
- (BOOL)isConnect;
- (void)writeData:(NSData *)data;

/** 开启socket任务 */
- (uint32_t)startSocketTask:(HYTCPSocketRequest *)request complection:(void(^)(NSDictionary *dict,NSError *error))complection;

- (void)resumeTask:(HYTCPSocketTask *)task;

/** 取消socket任务 */
- (void)cancelSocketTaskWithIdentifier:(uint32_t)taskIdentifier;


@end
