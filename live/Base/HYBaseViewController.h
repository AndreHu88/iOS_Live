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

/** presentViewController */
+ (void)presentVC:(UIViewController *)viewController;

/** pushToViewContrller */
+ (void)pushToVC:(UIViewController *)viewController;

/** handle notification */
+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState;

+ (UIViewController *)getCurrentVC;

- (void)setStatusBarBackgroundColor:(UIColor *)color;

- (void)setupNav;

- (void)backBtnAction;

- (void)tabBarItemClicked;

@end
