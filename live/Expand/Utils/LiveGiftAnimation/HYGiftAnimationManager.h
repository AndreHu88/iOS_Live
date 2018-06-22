//
//  HYGiftAnimationManager.h
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//
/***
 礼物动画原理（为保证礼物的实时性，礼物采用IM消息发送）
 1.收到IM礼物消息，实时增加礼物数量
 2.如果超出连击的时间间隔，则重新计数
 3.如果在时间间隔内，则在原来的基础上累加
 
 把每一条IM礼物消息看做一个动画操作，先进先出，使用队列的方式，以用户ID为key，创建礼物缓冲池和操作缓冲池
 后面收到礼物消息时：
 礼物缓冲池中有礼物信息
     操作缓冲池中没有动画操作，创建操作，从上次礼物数量开始累加
     操作缓冲池有动画操作，直接从上次礼物数量开始累加
 礼物缓冲池中没有礼物信息
     操作缓存池没有动画操作，创建操作，从 1 开始累加
     操作缓存池有动画操作，直接从上次礼物数量开始累加
 */

#import <Foundation/Foundation.h>
#import "HYGiftShowModel.h"
#import "HYAnimationOperation.h"

@interface HYGiftAnimationManager : NSObject

@property (nonatomic,strong) UIView *containerView;

+ (instancetype)sharedManager;

- (void)giftAnimationWithUserID:(NSString *)userID giftShowModel:(HYGiftShowModel *)showModel animationFinishBlock:(void(^)(BOOL result))finishBlcok;

- (void)cancelGiftAnimationWithUserID:(NSString *)userID;

@end
