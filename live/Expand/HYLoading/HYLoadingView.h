//
//  HYLoadingView.h
//  LoadingDemo
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYLoadingView : UIView

/** 圈圈转的loading */
- (void)showCircleLoading;

/** 点的动画 */
- (void)showDotLoading;

/** 线的动画 */
- (void)showLineLoading;

- (void)showInkeLoading;

@end
