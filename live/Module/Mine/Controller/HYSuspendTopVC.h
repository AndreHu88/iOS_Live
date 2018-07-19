//
//  HYSuspendTopVC.h
//  live
//
//  Created by Duntech on 2018/7/18.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYSuspendViewControllerDataSource <NSObject>

- (UIScrollView *)suspendScrollViewWithViewController:(UIViewController *)viewController pageIndex:(NSInteger)pageIndex;

@end

@interface HYSuspendTopVC : UIViewController

+ (instancetype)suspendTopWithTitleArray:(NSArray *)titleArray suspendViewControllers:(NSArray *)viewControllers;

@property (nonatomic,weak)   id<HYSuspendViewControllerDataSource> dataSource;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,assign) NSInteger pageIndex;

@end
