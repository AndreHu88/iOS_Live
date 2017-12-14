//
//  HYLiveMessageModel.h
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    直播聊天室数据模型类
 */
@interface HYLiveMessageModel : NSObject

/*!
    目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

/*!
    消息ID
 */
@property(nonatomic, assign) long messageId;

/*!
    发送者的用户ID
 */
@property(nonatomic, strong) NSString *senderUserId;

/*!
    消息的内容
 */
@property (nonatomic, strong) RCMessageContent *content;

/*!
    消息的附加字段
 */
@property (nonatomic, strong) NSString *extra;

/*!
    消息展示时的Cell高度
 
    @discussion 用于大量消息的显示优化
 */
@property (nonatomic, assign) CGFloat cellHeight;


/*!
    初始化消息Cell的数据模型
 
    @param chatMessage   消息模型
    @return            消息Cell的数据模型对象
 */
- (instancetype)initWithMessage:(RCMessage *)chatMessage;

@end
