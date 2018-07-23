//
//  HYSuspendTopVC.h
//  live
//
//  Created by Duntech on 2018/7/18.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYBaseViewController.h"

@class HYSuspendTopVC;

@protocol HYSuspendViewControllerDataSource <NSObject>

/// 返回scrollView
- (UIScrollView *)suspendScrollViewWithViewController:(HYSuspendTopVC *)viewController pageIndex:(NSInteger)pageIndex;

@end

@protocol HYSuspendViewControllerDelegate <NSObject>

- (void)suspendScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface HYSuspendTopVC : HYBaseViewController

+ (instancetype)suspendTopWithTitleArray:(NSArray *)titleArray suspendViewControllers:(NSArray *)viewControllers;

@property (nonatomic,weak)  id<HYSuspendViewControllerDataSource> dataSource;

@property (nonatomic,weak)  id<HYSuspendViewControllerDelegate> delegate;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSMutableArray *suspendVCArrays;   //自控制器array

@end
