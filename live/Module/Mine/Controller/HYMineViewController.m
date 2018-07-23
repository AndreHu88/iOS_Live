//
//  HYMineViewController.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYMineViewController.h"
#import "HYUserProfileViewController.h"


@interface HYMineViewController ()

@end

@implementation HYMineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    HYEmotionInputView *inputView = [HYEmotionInputView sharedInputView];
    [self.view addSubview:inputView];
    
    [self setUserProfileBtn];
}

- (void)setUserProfileBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        HYUserProfileViewController *userProfileVC = [HYUserProfileViewController userProfile];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
