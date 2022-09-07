//
//  AppDelegate.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "AppDelegate.h"
#import "HYTabBarController.h"
#import "HYBaseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KAPP_TableView_BgColor;
    [self.window makeKeyAndVisible];
    
    KEYWINDOW.rootViewController = [HYTabBarController new];
    //开启远程接收时间
    [application beginReceivingRemoteControlEvents];
    [HYCrashHandle sharedInstance];
//    [[HYTCPSocketManager shareInstance] connect];
    return YES;
}


- (void)setupNavBarAppearence{
    
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    [WRNavigationBar wr_setDefaultNavBarTintColor:KAPP_THEME_COLOR];
    [WRNavigationBar wr_setDefaultNavBarTitleColor:KAPP_WHITE_COLOR];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //APP变为活跃时
    UIViewController *currentViewController = [HYBaseViewController getCurrentVC];
    SEL refreshSelector = NSSelectorFromString(@"refresh");
    if ([currentViewController respondsToSelector:refreshSelector]) {
        //如果当前的VC可以响应此方法
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [currentViewController performSelector:refreshSelector];
#pragma clang diagnostic pop
        
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
