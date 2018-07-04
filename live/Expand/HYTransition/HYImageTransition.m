//
//  HYImageTransition.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYImageTransition.h"
#import "HYImageInteractivePushAnimation.h"
#import "HYImageInteractivePopAnimation.h"
#import "HYImageInteractiveDriven.h"

@interface HYImageTransition()

/** push动画代理 */
@property (nonatomic,strong) HYImageInteractivePushAnimation *pushAnimation;
/** pop动画代理 */
@property (nonatomic,strong) HYImageInteractivePopAnimation *popAnimation;
/** 交互 */
@property (nonatomic,strong) HYImageInteractiveDriven *interActiveDirven;

@end

@implementation HYImageTransition

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        
        
        return self.pushAnimation;
    }
    else if (operation == UINavigationControllerOperationPop){
        
        return self.popAnimation;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    if (self.pan) {
        
        return self.interActiveDirven;
    }
    return nil;
}

#pragma mark - lazyload
- (HYImageInteractivePushAnimation *)pushAnimation{
    
    if (!_pushAnimation) {
        
        _pushAnimation = [[HYImageInteractivePushAnimation alloc] init];
        _pushAnimation.transitionBeforeFrame = self.beforeFrame;
        _pushAnimation.transitionAfterFrame = self.afterFrame;
        _pushAnimation.transitionBeforeImgView = self.transitionBeforeImgView;
    }
    return _pushAnimation;
}

- (HYImageInteractivePopAnimation *)popAnimation{
    
    if (!_popAnimation) {
        
        _popAnimation = [HYImageInteractivePopAnimation new];
        _popAnimation.transitionBeforeFrame = self.beforeFrame;
        _popAnimation.transitionAfterFrame = self.afterFrame;
        _popAnimation.transitionBeforeImgView = self.transitionBeforeImgView;
    }
    return _popAnimation;
}

- (HYImageInteractiveDriven *)interActiveDirven{
    
    if (!_interActiveDirven) {
        
        _interActiveDirven = [[HYImageInteractiveDriven alloc] initWithGesture:self.pan];
        _interActiveDirven.screenShotImg = self.screenShotImg;
        _interActiveDirven.transitionBeforeFrame = self.beforeFrame;
        _interActiveDirven.transitionAfterFrame = self.afterFrame;
        _interActiveDirven.currentImgView = self.transitionBeforeImgView;
    }
    return _interActiveDirven;
}

@end
