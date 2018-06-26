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
    
    HYEmotionInputView *inputView = [HYEmotionInputView sharedInputView];
    [self.view addSubview:inputView];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
