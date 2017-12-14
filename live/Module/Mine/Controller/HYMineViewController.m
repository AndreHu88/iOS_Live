//
//  HYMineViewController.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYMineViewController.h"

@interface HYMineViewController ()

@end

@implementation HYMineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
}

- (void)setupNav{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航栏的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:KAPP_WHITE_COLOR}];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
