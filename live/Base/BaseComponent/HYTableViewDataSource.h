//
//  HYTableViewDataSource.h
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBaseTableViewCell.h"
#import "HYBaseCellModel.h"

typedef void(^BindingCellBlock)(UITableView *tableView,id rowDataSource,HYBaseTableViewCell *cell,NSIndexPath *indexPath);

@interface HYTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic,assign) NSInteger sectionCount;
@property (nonatomic,weak)   NSMutableArray <NSMutableArray <HYBaseCellModel *> *> *dataSource;
/** 设置Cell */
@property (nonatomic,copy)   BindingCellBlock bindingCellBlock;
/** 是否可以编辑 */
@property (nonatomic,copy)   BOOL (^CellCanEditBlock)(UITableView *tableView,NSIndexPath *indexPath);
/** 设置EditingStyle */
@property (nonatomic,copy)   void (^CommitEditingBlock)(UITableView *tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath *indexPath);

@end
