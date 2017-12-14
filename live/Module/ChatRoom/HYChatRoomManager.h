//
//  HYChatRoomManager.h
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYChatRoomManager : NSObject <UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic,strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *datalist;

- (instancetype)initWithFrame:(CGRect)frame;

@end
