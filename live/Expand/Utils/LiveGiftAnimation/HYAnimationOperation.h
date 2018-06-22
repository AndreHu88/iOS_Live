//
//  HYAnimationOperation.h
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYGiftShowModel.h"
#import "HYGiftAnimationView.h"

@interface HYAnimationOperation : NSOperation

@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) HYGiftAnimationView *animationView;

+ (instancetype)animationOperationWithUserID:(NSString *)userID giftShowModel:(HYGiftShowModel *)giftModel superView:(UIView *)parentView finishBlock:(void(^)(BOOL isFinish, NSInteger finishCount))finishedBlock;



@end
