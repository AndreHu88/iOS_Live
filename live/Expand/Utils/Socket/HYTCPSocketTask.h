//
//  HYTCPSocketTask.h
//  live
//
//  Created by Duntech on 2018/7/10.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTCPSocketResponse.h"
#import "HYSocketConfig.h"

@interface HYTCPSocketTask : NSObject

+ (instancetype)taskWithRequest:(HYTCPSocketRequest *)request complection:(void(^)(NSDictionary *result, NSError *error))complectionHandler;

@property (nonatomic,strong) HYTCPSocketRequest *request;

- (TCPSocketTaskState)state;

- (uint32_t)taskIdentifier;

- (void)cancelTask;

- (void)resume;



@end
