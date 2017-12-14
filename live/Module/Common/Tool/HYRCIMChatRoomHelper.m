//
//  HYRCIMChatRoomHelper.m
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

/**
 name = "皇上";
 protraitUrl = "huangshang.jpg";
 userId = "1511924913.560936";
 token = "hFLoKfyQsL0dbHtxLrwJPbJNwZccds+d3rQltCcfdiWTnD3FcqPfM2dPx3CEQiEvXMNjKlLHPlCxS/TKn0cv7heE6qsef4Y0pR5crIqh9ZU="
 */

#import "HYRCIMChatRoomHelper.h"

@implementation HYRCIMChatRoomHelper

+ (void)setupRCIMWithComplectionBlock:(void (^)(BOOL))resultBlock{
    
    [[RCIMClient sharedRCIMClient] initWithAppKey:RONGCLOUD_IM_APPKEY];
    NSString *token = @"hFLoKfyQsL0dbHtxLrwJPbJNwZccds+d3rQltCcfdiWTnD3FcqPfM2dPx3CEQiEvXMNjKlLHPlCxS/TKn0cv7heE6qsef4Y0pR5crIqh9ZU=";
    
    if ([RCIMClient sharedRCIMClient].getConnectionStatus == ConnectionStatus_Connected || [RCIMClient sharedRCIMClient].getConnectionStatus == ConnectionStatus_Connecting) {
        
        return;
    }
    
    [[RCIMClient sharedRCIMClient] connectWithToken:token
    success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        RCUserInfo *user = [[RCUserInfo alloc] init];
        user.userId = @"1511924913.560936";
        user.portraitUri = @"huangshang.jpg";
        user.name = @"皇上";
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        resultBlock(YES);
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"登陆的错误码为:%ld", (long)status);
        resultBlock(NO);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        resultBlock(NO);

    }];
}

+ (void)joinChatRoomWithTargetID:(NSString *)targetID resultBlock:(void (^)(BOOL))resultBlock{
    
    [[RCIMClient sharedRCIMClient] joinChatRoom:targetID messageCount:3 success:^{
        
        resultBlock(YES);
        
    } error:^(RCErrorCode status) {
        
        DLog(@"----加入聊天室失败:%ld",(long)status);
        resultBlock(NO);
    }];
}

+ (void)quitChatRoomWithTargetID:(NSString *)targetID resultBlock:(void (^)(BOOL))resultBlock{
    
    [[RCIMClient sharedRCIMClient] quitChatRoom:targetID success:^{
        
        DLog(@"退出聊天室成功");
        resultBlock(YES);
        
    } error:^(RCErrorCode status) {
        
        DLog(@"----加入聊天室失败:%ld",(long)status);
        resultBlock(NO);
    }];
}

+ (void)sendMessageWithTargetID:(NSString *)targetID content:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent pushData:(NSString *)pushData success:(void (^)(long))successBlock error:(void (^)(RCErrorCode, long))errorBlock{
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_CHATROOM targetId:targetID content:messageContent pushContent:pushContent pushData:pushData success:^(long messageId) {
        
        successBlock(messageId);
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
        errorBlock(nErrorCode,messageId);
    }];
}

@end
