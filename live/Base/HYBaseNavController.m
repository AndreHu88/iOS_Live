//
//  HYBaseNavController.m
//  Agency
//
//  Created by 胡勇 on 2017/11/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYBaseNavController.h"
#import "HYSmallVideoPlayerVC.h"

@interface HYBaseNavController () <UINavigationControllerDelegate>

@end

@implementation HYBaseNavController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark --------navigation delegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count) {
        
        if (![viewController isKindOfClass:[HYSmallVideoPlayerVC class]]) {
            
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backBtnAction{
    
    if (self.viewControllers.count) {
        
        [self popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
