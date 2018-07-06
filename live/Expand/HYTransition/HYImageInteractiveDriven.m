//
//  HYImageInteractiveDriven.m
//  live
//
//  Created by Jack on 2017/12/8.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYImageInteractiveDriven.h"

@interface HYImageInteractiveDriven()

/** 转场context */
@property (nonatomic,assign) id<UIViewControllerContextTransitioning> transitionContext;
/** 拖拽手势 */
@property (nonatomic,strong) UIPanGestureRecognizer *panGes;
/** 截图 */
@property (nonatomic,strong) UIImageView *snapShotImgView;
@property (nonatomic,strong) UIView *beforeWhiteView;
/** 黑色背景用于渐变 */
@property (nonatomic,strong) UIView *blackBgView;

@end

@implementation HYImageInteractiveDriven

- (instancetype)initWithGesture:(UIPanGestureRecognizer *)gesture{
    
    if (self = [super init]) {
        
        self.panGes = gesture;
        [gesture addTarget:self action:@selector(panGestureAction:)];
    }
    return self;
}

#pragma mark - action
- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    
    CGFloat precent = [self precentDrivenForGestrue:pan];

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:
            //更新百分比
            [self updateInteractiveTransition:precent];
            [self updateDrivenPercent:precent];
            break;
        case UIGestureRecognizerStateEnded:
            
            if (precent > 0.23) {
                
                [self finishInteractiveTransition];
                [self drivenPercentFinish];
            }
            else{
                [self cancelInteractiveTransition];
                [self drivenCancel];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            [self drivenCancel];
            break;
    }
}

#pragma mark - 拖动过程
//开始拖动
- (void)startDrivenPrecent{
    
    UIView *containerView = [self.transitionContext containerView];
//    UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *toView = toVC.view;
//    [containerView addSubview:toView];
    
    [KEYWINDOW addSubview:self.snapShotImgView];
    
    //有渐变的黑色背景
    _blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    _blackBgView.backgroundColor = [UIColor blackColor];
    [KEYWINDOW addSubview:_blackBgView];
    
    UIViewController *fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.backgroundColor = [UIColor clearColor];
    UIView *fromeView = fromVC.view;
    [KEYWINDOW addSubview:fromeView];
}

- (void)updateDrivenPercent:(CGFloat)percent{
    
    //更改背景的透明度
    self.blackBgView.alpha = 1 - percent * 3.5;
}

- (void)drivenCancel{
    
    UIView *containerView = [self.transitionContext containerView];
    UIViewController *fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [containerView addSubview:fromVC.view];

    
    [_snapShotImgView removeFromSuperview];
    _snapShotImgView = nil;
    [_blackBgView removeFromSuperview];
    _blackBgView = nil;
    [self.transitionContext completeTransition:NO];
}

- (void)drivenPercentFinish{
    
    UIView *containerView = [self.transitionContext containerView];
    UIViewController *toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.top += KNavTotal_HEIGHT;
    [containerView addSubview:toVC.view];

    UIImageView *transitionImgView = [[UIImageView alloc] initWithFrame:self.transitionBeforeFrame];
    transitionImgView.image = self.currentImgView.image;
    [containerView addSubview:transitionImgView];
    
    //创建一个黑色的背景
//    UIView *blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
//    blackBgView.backgroundColor = KAPP_BLACK_COLOR;
//    [containerView addSubview:blackBgView];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect beforeFrame = self.transitionAfterFrame;
//        //需要将y下移64，因为有导航栏x
        beforeFrame.origin.y += 64;
        transitionImgView.frame = beforeFrame;
       
    } completion:^(BOOL finished) {
        
        NSLog(@"panGesture animation finished");
        [transitionImgView removeFromSuperview];
        
        [_snapShotImgView removeFromSuperview];
        _snapShotImgView = nil;
        [_blackBgView removeFromSuperview];
        _blackBgView = nil;
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    }];
}

//计算拖动的比例
- (CGFloat)precentDrivenForGestrue:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint translationPoint = [panGesture translationInView:panGesture.view];
    CGFloat precent = translationPoint.y / KSCREEN_HEIGHT;
    precent = precent < 0 ? 0 : precent;
    precent = precent > 1 ? 1 : precent;
    return precent;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    [self startDrivenPrecent];
}

#pragma mark - lazyload
- (UIImageView *)snapShotImgView{
    
    if (!_snapShotImgView) {
        
        _snapShotImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _snapShotImgView.image = self.screenShotImg;
        _snapShotImgView.alpha = 1;
    }
    return _snapShotImgView;
}

- (UIView *)blackBgView{
    
    if (!_blackBgView) {
        
        _blackBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackBgView.backgroundColor = [UIColor blackColor];
        _blackBgView.alpha = 1;
    }
    return _blackBgView;
}

@end
