//
//  HYHotLiveViewController.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYHotLiveViewController.h"
#import "HYLiveTableViewCell.h"
#import "HYCurrentLiveViewController.h"

@interface HYHotLiveViewController()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datalist;

@end

@implementation HYHotLiveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self requestData];
}

- (void)viewDidLayoutSubviews{
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData{
    
    [HYNetWorkHandle getHotLiveListComplectionBlock:^(NSArray *datalist) {
        
        if (datalist) {
            
            [self.datalist removeAllObjects];
            
            [datalist enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                
                HYHotLiveModel *model = [HYHotLiveModel modelWithDictionary:dict[@"live"]];
                [self.datalist addObject:model];
            }];
            
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    }];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *liveCellID = @"liveCellID";
    HYLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liveCellID];
    if (!cell) {
        cell = [[HYLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.model = self.datalist[indexPath.row];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYCurrentLiveViewController *liveVC = [HYCurrentLiveViewController new];
    liveVC.currentIndex = indexPath.row;
    liveVC.modelList = self.datalist;
    liveVC.liveModel = self.datalist[indexPath.row];
    [self.navigationController pushViewController:liveVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYHotLiveModel *model = self.datalist[indexPath.row];
    return model.cellHeight;
}


#pragma mark - 没有数据
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *text = @"全世界都在等待你的直播";
    NSDictionary *attributes = @{NSFontAttributeName : KFitFont(14),NSForegroundColorAttributeName : KAPP_b7b7b7_COLOR};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    UIImage *image = [UIImage imageNamed:@"default_network_empty"];
    return image;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    
    [self requestData];
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [HYRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _tableView.backgroundColor = KAPP_TableView_BgColor;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)datalist{
    
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
