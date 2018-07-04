//
//  MBProgressHUD+HYCommon.h
//  Token_iOS
//
//  Created by Duntech on 2018/6/5.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (HYCommon)

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

/**
 *    展示错误信息
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *    展示成功信息
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;


@end
