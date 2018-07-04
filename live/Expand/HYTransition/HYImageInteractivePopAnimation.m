//
//  HYImageInteractivePopAnimation.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYImageInteractivePopAnimation.h"

@implementation HYImageInteractivePopAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //转场的容器
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *toViewContrller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewContrller.view;
    toView.top += KNavTotal_HEIGHT;
    [containerView addSubview:toView];
    
    //创建一个和之前的图片位置一样的View
    UIView *imgBgView = [[UIView alloc] initWithFrame:self.transitionAfterFrame];
    imgBgView.top += KNavTotal_HEIGHT;
    imgBgView.backgroundColor = KAPP_WHITE_COLOR;
    imgBgView.hidden = YES;
    [containerView addSubview:imgBgView];
    
    UIImageView *transitionImgView = [[UIImageView alloc] initWithFrame:self.transitionAfterFrame];
    transitionImgView.top += KNavTotal_HEIGHT;
    transitionImgView.image = self.transitionBeforeImgView.image;
    [containerView addSubview:transitionImgView];
    
    //创建一个黑色的背景
    UIView *blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    blackBgView.backgroundColor = KAPP_BLACK_COLOR;
    [containerView addSubview:blackBgView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect beforeFrame = self.transitionBeforeFrame;
        //需要将y下移64，因为有导航栏
        beforeFrame.origin.y += 64;
        transitionImgView.frame = beforeFrame;
        blackBgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        //移除没用的View
        [imgBgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        [blackBgView removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}


@end
