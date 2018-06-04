//
//  HYTableViewDelegate.h
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYTableViewDelegate : NSObject <UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *dataSource;

/**
 *  必须实现，返回高度
 */
@property(nonatomic,copy) CGFloat(^rowHeightBlock)(UITableView *tableView,NSIndexPath *indexPath);

/**
 *  可选
 */
@property(nonatomic,copy) CGFloat(^headerHeightBlock)(UITableView *tableView,NSInteger section);

/**
 *  可选
 */
@property(nonatomic,copy) CGFloat(^footerHeightBlock)(UITableView *tableView,NSInteger section);

/**
 *  可选
 */
@property(nonatomic,copy) UIView *(^headerViewBlock)(UITableView *tableView,NSInteger section);

/**
 *  可选
 */
@property(nonatomic,copy) UIView *(^footerViewBlock)(UITableView *tableView,NSInteger section);

/**
 *  可选，点击某个tableviewcell，回调
 */
@property(nonatomic,copy) void(^didSelectedBlock)(UITableView *tableView,NSIndexPath *indexPath);

/**
 *  可选
 */
@property (nonatomic,copy) void (^willDisplayBlock)(UITableView *tableView,UITableViewCell *cell,NSIndexPath *indexPath);

/**
 *  tableView滚动
 */
@property (nonatomic,copy) void (^scrollViewDidScrill)(UIScrollView *scorllView);

/**
 *  tableView侧滑编辑
 */
@property (nonatomic,copy) NSArray *(^editActionBlock)(UITableView *tableView,NSIndexPath *indexPath);

@end
