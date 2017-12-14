//
//  MBProgressHUD+HYExtension.h
//  FlowerHan
//
//  Created by 胡勇 on 2017/6/9.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (HYExtension)

/**
 *    展示HUD
 */
+ (void)showPregressHUD:(UIView *)view;

/**
 *    隐藏HUD
 */
+ (void)hidePregressHUD:(UIView *)view;


/**
 *    MBProgressHUD文本弹框
 */
+ (void)showPregressHUD:(UIView *)view withText:(NSString *)text;

/**
 *    MBProgressHUD加载
 */
+ (void)showPregressHUDWithLoadingText:(NSString *)text;

@end
