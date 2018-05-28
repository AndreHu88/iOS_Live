//
//  HYBaseViewController.h
//  Agency
//
//  Created by 胡勇 on 2017/11/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WRCustomNavigationBar.h>

@interface HYBaseViewController : UIViewController

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

- (void)setStatusBarBackgroundColor:(UIColor *)color;

- (void)setupNav;

- (void)backBtnAction;

+ (UIViewController *)getCurrentVC;

@end
