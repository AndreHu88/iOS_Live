//
//  HYBaseTableViewController.h
//  live
//
//  Created by Jack on 2017/11/28.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface HYBaseTableViewController : UITableViewController <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray *datalist;

@end
