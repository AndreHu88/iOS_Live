//
//  HYLoadingManager.h
//  LoadingDemo
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLoadingManager : NSObject

/** 圈圈转的loading */
+ (void)showCircleLoading;

/** 点的动画 */
+ (void)showDotLoading;

/** 线的动画 */
+ (void)showLineLoading;

/** inke加载动画 */
+ (void)showInkeLoading;

/** 移除动画视图 */
+ (void)dismissLoadingView;

/** 是否开启用户交互 */
+ (void)enableUserInteraction:(BOOL)enabled;

@end
