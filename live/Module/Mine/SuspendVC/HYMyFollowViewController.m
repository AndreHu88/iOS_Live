//
//  HYMyFollowViewController.m
//  live
//
//  Created by Duntech on 2018/7/20.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYMyFollowViewController.h"

@interface HYMyFollowViewController () <UITableViewDelegate,UITableViewDataSource>


@end

@implementation HYMyFollowViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"tableView:%ld",(long)indexPath.row];
    return cell;
}

#pragma mark - lazyload
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
        }];
    }
    return _tableView;
}

@end
