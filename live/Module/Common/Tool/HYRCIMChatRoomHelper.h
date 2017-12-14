//
//  HYRCIMChatRoomHelper.h
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RONGCLOUD_IM_APPKEY @"e5t4ouvptkm2a"
#define RONGCLOUD_IM_APPSECRET @"vB4FakXm8f68"

@interface HYRCIMChatRoomHelper : NSObject

+ (void)setupRCIMWithComplectionBlock:(void(^)(BOOL isSuccess))resultBlock;

+ (void)joinChatRoomWithTargetID:(NSString *)targetID resultBlock:(void(^)(BOOL isSuccess))resultBlock;

+ (void)quitChatRoomWithTargetID:(NSString *)targetID resultBlock:(void(^)(BOOL isSuccess))resultBlock;

/** 发送消息 */
+ (void)sendMessageWithTargetID:(NSString *)targetID
                        content:(RCMessageContent *)messageContent
                    pushContent:(NSString *)pushContent
                       pushData:(NSString *)pushData
                        success:(void (^)(long messageId))successBlock
                          error:(void (^)(RCErrorCode nErrorCode,
                                          long messageId))errorBlock;

@end
