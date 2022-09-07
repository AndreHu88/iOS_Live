//
//  HYBaseViewController.m
//  Agency
//
//  Created by 胡勇 on 2017/11/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYBaseNavController.h"
#import "HYTabBarController.h"

@interface HYBaseViewController ()

@end

@implementation HYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    self.view.backgroundColor = KAPP_TableView_BgColor;
//    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
}

- (void)dealloc{
    
    NSLog(@"%@ dealloc",[self description]);
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.view endEditing:YES];
}

- (void)setupNav{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    //设置导航栏的颜色
//    self.navigationController.navigationBar.barTintColor = KAPP_NAV_COLOR;
//    //设置导航栏的字体颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:KAPP_WHITE_COLOR}];
//    self.navigationController.navigationBar.translucent = NO;
//
//    //设置返回按钮的颜色为白色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];


    [self wr_setNavBarTintColor:KAPP_WHITE_COLOR];
    [self wr_setNavBarTitleColor:KAPP_WHITE_COLOR];
    [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    [self wr_setNavBarBackgroundAlpha:1.0];
    [self wr_setNavBarBarTintColor:KAPP_THEME_COLOR];
    
    if (self.navigationController.viewControllers.count > 1) {
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
}

- (void)backBtnAction{
    
    if (self.navigationController.viewControllers.count > 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

#pragma mark - PublicMethod
+ (UIViewController *)getCurrentVC{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[HYTabBarController class]]) {
        result = [(HYTabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (void)presentVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [[HYBaseNavController alloc] initWithRootViewController:viewController];
    if (!viewController.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalVC)];
    }
    [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

+ (void)pushToVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [self getCurrentVC].navigationController;
    if (nav) {
        [nav pushViewController:viewController animated:YES];
    }
}

+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState{
    
    switch (applicationState) {
        case UIApplicationStateActive:{
            //APP在前台
            
        }
            break;
        case UIApplicationStateInactive:{
            //APP在待激活 (锁屏 下拉通知栏 锁屏)
        }
            break;
        case UIApplicationStateBackground:{
            //当前应用在后台
            
        }
            break;
        default:
            break;
    }
}

- (void)tabBarItemClicked{
    
    DLog(@"tabBarItemClicked:%@",NSStringFromClass([self class]));
}

- (void)dismissModalVC{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        
//        statusBar.backgroundColor = color;
//    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
