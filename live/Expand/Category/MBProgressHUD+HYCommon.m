//
//  MBProgressHUD+HYCommon.m
//  Token_iOS
//
//  Created by Duntech on 2018/6/5.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "MBProgressHUD+HYCommon.h"

@implementation MBProgressHUD (HYCommon)

+ (void)showPregressHUD:(UIView *)view{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:HUD];
    
    HUD.bezelView.color = [UIColor blackColor];            //设置菊花背景颜色
    HUD.contentColor = [UIColor whiteColor];               //设置内容颜色
    [HUD showAnimated:YES];
}

+ (void)hidePregressHUD:(UIView *)view{
    
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+ (void)showPregressHUD:(UIView *)view withText:(NSString *)text{
    
    if ([text isKindOfClass:[NSNull class]] || text.length == 0) return;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:HUD];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    HUD.label.text = text;
    HUD.contentColor = [UIColor whiteColor];
    
    //显示对话框
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
    
}

+ (void)showPregressHUDWithLoadingText:(NSString *)text{
    
    text = text.length > 0 ? text : @"正在获取数据..";
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    [KEYWINDOW addSubview:HUD];
    HUD.bezelView.color = [UIColor blackColor];            //设置菊花背景颜色
    HUD.contentColor = [UIColor whiteColor];               //设置内容颜色
    HUD.label.text = text;
    HUD.margin = 10;
    [HUD showAnimated:YES];
}

+ (void)showError:(NSString *)error toView:(UIView *)view{
    
    [self show:error icon:@"error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    
    [self show:success icon:@"success" view:view];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.label.text = text;
    hud.contentColor = [UIColor whiteColor];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}


@end
