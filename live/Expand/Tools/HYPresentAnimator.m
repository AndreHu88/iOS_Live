//
//  HYPresentAnimator.m
//  live
//
//  Created by Duntech on 2018/5/16.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYPresentAnimator.h"

@interface HYPresentAnimator () <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic,assign) BOOL isPresented;
@property (nonatomic,assign) CGFloat transitionDuration;
@property (nonatomic,assign) CGRect presentViewFrame;
/** 定义两个属性来持有传过来的block */
@property (nonatomic,copy)   void (^presentAnimationBlock)(UIView *presentedView,UIView *containerView,void(^complection)(BOOL finished));
@property (nonatomic,copy)   void (^dismissAnimationBlock)(UIView *dismissView,void(^complection)(BOOL  finished));

@end

@implementation HYPresentAnimator

+ (void)presentFromViewController:(UIViewController *)fromViewController presentViewController:(UIViewController *)toViewController presentViewFrame:(CGRect)presentViewFrame animated:(BOOL)animated completion:(void (^)(void))completion animatedDuration:(NSTimeInterval)duration presentAnimation:(void (^)(UIView *, UIView *, void (^)(BOOL)))presentAnimation dismissAnimation:(void (^)(UIView *, void (^)(BOOL)))dismissAnimation{
    
    HYPresentAnimator *animator = [[HYPresentAnimator alloc] init];
    animator.transitionDuration =  duration;
    animator.presentAnimationBlock = presentAnimation;
    animator.dismissAnimationBlock = dismissAnimation;
    animator.presentViewFrame = presentViewFrame;
    
    toViewController.modalPresentationStyle = UIModalPresentationCustom;
    toViewController.transitioningDelegate = animator;
    [fromViewController presentViewController:toViewController animated:animated completion:completion];
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    //分present 和 dismiss分别处理
    if (self.isPresented) {
        [self presentTransition:transitionContext];
    }
    else{
        [self dismissTransition:transitionContext];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    
    return self.transitionDuration;
}


- (void)presentTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext{
    
    // A presentViewController B 后，a.presentedViewController就是b，b.presentingViewController就是a，
    UIView *containerView = transitionContext.containerView;
    UIView *presentView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [containerView addSubview:presentView];
    if (self.presentAnimationBlock) {
        
        self.presentAnimationBlock(presentView, containerView, ^(BOOL finished) {
           
            ///当view的缩放动画完成的时候, 一定要告诉转场上下文
            [transitionContext completeTransition:finished];
        });
    }
    else{
        [transitionContext completeTransition:YES];
    }
    
}

- (void)dismissTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (self.dismissAnimationBlock) {
        
        self.dismissAnimationBlock(dismissView, ^(BOOL finished){
            
            [dismissView removeFromSuperview];
            [transitionContext completeTransition:finished];
        });
    }
    else{
        [dismissView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    HYPresentationViewContrller *presentationVC = [[HYPresentationViewContrller alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    if (CGRectIsEmpty(self.presentViewFrame)) {
        presentationVC.presentViewFrame = [UIScreen mainScreen].bounds;
    }
    else{
        presentationVC.presentViewFrame = self.presentViewFrame;
    }
    return presentationVC;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    self.isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    self.isPresented = NO;
    return self;
}

@end

@implementation HYPresentationViewContrller

- (void)containerViewWillLayoutSubviews{
    
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = self.presentViewFrame;
}

@end
