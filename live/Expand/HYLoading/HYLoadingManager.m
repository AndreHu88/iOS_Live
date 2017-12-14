//
//  HYLoadingManager.m
//  LoadingDemo
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLoadingManager.h"
#import "HYLoadingView.h"

@implementation HYLoadingManager

/** 圈圈转的loading */
+ (void)showCircleLoading{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    HYLoadingView *loadingView = [[HYLoadingView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:loadingView];
    [loadingView showCircleLoading];
}

/** 点的动画 */
+ (void)showDotLoading{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    HYLoadingView *loadingView = [[HYLoadingView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:loadingView];
    [loadingView showDotLoading];
}

/** 线的动画 */
+ (void)showLineLoading{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    HYLoadingView *loadingView = [[HYLoadingView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:loadingView];
    [loadingView showLineLoading];
}

+ (void)showInkeLoading{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    HYLoadingView *loadingView = [[HYLoadingView alloc] initWithFrame:keyWindow.bounds];
    [keyWindow addSubview:loadingView];
    [loadingView showInkeLoading];
}

+ (void)enableUserInteraction:(BOOL)enabled{
    
    HYLoadingView *loadingView = [self getLoadingView];
    loadingView.userInteractionEnabled = !enabled;
}

+ (void)dismissLoadingView{
    
    HYLoadingView *loadingView = [self getLoadingView];
    [loadingView removeFromSuperview];
}

/** 获取到loadingView(仿MBProgressHUD写法) */
+ (HYLoadingView *)getLoadingView{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    NSEnumerator *subviewEnumrator = [keyWindow.subviews reverseObjectEnumerator];
    for (UIView *subView in subviewEnumrator) {
        
        if ([subView isKindOfClass:[HYLoadingView class]]) {
            
            return (HYLoadingView *)subView;
        }
    }
    return nil;
}

@end
