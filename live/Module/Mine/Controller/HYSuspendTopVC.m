//
//  HYSuspendTopVC.m
//  live
//
//  Created by Duntech on 2018/7/18.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYSuspendTopVC.h"

@interface HYSuspendTopVC ()

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *controllersArray;

@end

@implementation HYSuspendTopVC

+ (instancetype)suspendTopWithTitleArray:(NSArray *)titleArray suspendViewControllers:(NSArray *)viewControllers{
    
    HYSuspendTopVC *suspendVC = [HYSuspendTopVC new];
    suspendVC.titleArray = titleArray.mutableCopy;
    suspendVC.controllersArray = viewControllers.mutableCopy;
    return suspendVC;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - public

#pragma mark - private


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
