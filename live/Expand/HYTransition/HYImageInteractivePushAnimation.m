//
//  HYImageInteractivePushAnimation.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYImageInteractivePushAnimation.h"

@implementation HYImageInteractivePushAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //转场的容器
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    [containerView addSubview:fromView];
    
    UIViewController *toViewContrller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewContrller.view;
    toView.hidden = YES;
    [containerView addSubview:toView];
    
    //创建一个和之前的图片位置一样的View
    UIView *imgBgView = [[UIView alloc] initWithFrame:self.transitionBeforeFrame];
    imgBgView.backgroundColor = KAPP_WHITE_COLOR;
    [containerView addSubview:imgBgView];
    
    UIImageView *transitionImgView = [[UIImageView alloc] initWithFrame:self.transitionBeforeFrame];
    transitionImgView.image = self.transitionBeforeImgView.image;
    [containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        transitionImgView.frame = self.transitionAfterFrame;
        
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        //移除没用的View
        [imgBgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
