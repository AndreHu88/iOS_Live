//
//  HYImageInteractivePopAnimation.h
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYImageInteractivePopAnimation : NSObject <UIViewControllerAnimatedTransitioning>

/** 转场之前的frame */
@property (nonatomic,assign) CGRect transitionBeforeFrame;
/** 转场之后的frame */
@property (nonatomic,assign) CGRect transitionAfterFrame;
/** 转场的imgView */
@property (nonatomic,strong) UIImageView *transitionBeforeImgView;

@end
