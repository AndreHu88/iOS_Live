//
//  HYTabBarController.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYTabBarController.h"
#import "HYCustomTabBar.h"
#import "HYHomeViewController.h"
#import "HYNearViewController.h"
#import "HYFocusViewController.h"
#import "HYMineViewController.h"
#import "HYBaseNavController.h"
#import "HYLocationManager.h"

@interface HYTabBarController ()

@end

@implementation HYTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //删除tabbar的阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    
    [self addAllChildVC];
    [[HYLocationManager sharedManager] getLocationInfo:^(NSString *lat, NSString *lot) {
        
        DLog(@"%@:%@",lat,lot);
    }];
}

- (void)addAllChildVC{
    
    // 利用KVO来使用自定义的tabBar
    [self setValue:[[HYCustomTabBar alloc] init] forKey:@"tabBar"];
    
    HYHomeViewController *homeVC = [HYHomeViewController new];
    [self addChildViewController:homeVC title:@"主页" image:@"tab_live" selectImage:@"tab_live_p"];
    
    HYNearViewController *nearVC = [HYNearViewController new];
    [self addChildViewController:nearVC title:@"附近" image:@"tab_near" selectImage:@"tab_near_p"];
    
    HYFocusViewController *focusVC = [HYFocusViewController new];
    [self addChildViewController:focusVC title:@"网易云" image:@"tab_following" selectImage:@"tab_following_p"];
    
    HYMineViewController *mineVC = [HYMineViewController new];
    [self addChildViewController:mineVC title:@"我的" image:@"tab_me" selectImage:@"tab_me_p"];
}


- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)imageName selectImage:(NSString *)selectImage{
    
    HYBaseNavController *nav = [[HYBaseNavController alloc] initWithRootViewController:vc];
    // 如果同时有navigationbar 和 tabbar的时候最好分别设置它们的title
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectImg = [UIImage imageNamed:selectImage];
    nav.tabBarItem.selectedImage = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    id selectedViewController = self.selectedViewController;
    if ([selectedViewController isKindOfClass:[HYBaseNavController class]]) {
        
        HYBaseNavController *navVC = (HYBaseNavController *)selectedViewController;
        if (navVC.topViewController != navVC.viewControllers[0]) {
            return;
        }
        
        if ([navVC.topViewController isKindOfClass:[HYBaseViewController class]]) {
            
            HYBaseViewController *currentVC = (HYBaseViewController *)navVC.topViewController;
            [currentVC tabBarItemClicked];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
