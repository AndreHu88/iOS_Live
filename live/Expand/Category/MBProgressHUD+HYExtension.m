//
//  MBProgressHUD+HYExtension.m
//  FlowerHan
//
//  Created by 胡勇 on 2017/6/9.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "MBProgressHUD+HYExtension.h"

@implementation MBProgressHUD (HYExtension)

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
    
    if ([text isKindOfClass:[NSNull class]] || text.length == 0) {
        return;
    }
    
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
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:KEYWINDOW animated:YES];
    [KEYWINDOW addSubview:HUD];
    
    HUD.bezelView.color = [UIColor blackColor];            //设置菊花背景颜色
    HUD.contentColor = [UIColor whiteColor];               //设置内容颜色
    HUD.label.text = text;
    [HUD showAnimated:YES];
}

@end
