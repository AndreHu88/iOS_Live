//
//  HYChatRoomManager.m
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYChatRoomManager.h"
#import "HYChatRoomCell.h"

@implementation HYChatRoomManager

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super init]) {
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = KAPP_Clear_COLOR;
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - tableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *chatRoomCellID = @"chatRoomCellID";
    HYChatRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:chatRoomCellID];
    if (!cell) {
        
        cell = [[HYChatRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatRoomCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.datalist[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datalist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYLiveMessageModel *model = self.datalist[indexPath.row];
    return model.cellHeight;
}

- (NSMutableArray *)datalist{
    
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

@end
