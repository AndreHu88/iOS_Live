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

//- (void)viewWillAppear:(BOOL)animated{
//    
//    __weak typeof(self) weakSelf = self;
//    [self.view beginLoading];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.view endLoading];
//        [self.view configBlankPageWithType:BlankPageTypeLive hasData:NO hasError:YES offset:0 reloadButtonBlock:^(id sender) {
//            
//            [weakSelf.view beginLoading];
//        }];
//    });
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
