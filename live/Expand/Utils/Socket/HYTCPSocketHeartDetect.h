//
//  HYTCPSocketHeartDetect.h
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSocketConfig.h"

@interface HYTCPSocketHeartDetect : NSObject

+ (instancetype)heartDetectWithSocketManager:(HYTCPSocketManager *)socketManager timeoutHandler:(void(^)(void))timeoutHandler;

- (void)stop;

- (void)reset;

- (void)handlerServerAck:(uint32_t)serverAckNum;

@end
