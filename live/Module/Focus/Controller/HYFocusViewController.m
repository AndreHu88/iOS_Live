//
//  HYFocusViewController.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYFocusViewController.h"
#import "HYMusicHandleTool.h"
#import "HYMusicPlayerVC.h"
#import "HYMusicListTableViewCell.h"

@interface HYFocusViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datalist;

@end

@implementation HYFocusViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setupNav];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)setupNav{
    
    [self wr_setNavBarBarTintColor:KAPP_NETEASE_COLOR];
    [self wr_setNavBarTitleColor:KAPP_WHITE_COLOR];
    self.title = @"网易云";
}

- (void)requestNetData{
    
    [HYNetWorkHandle getXiaMiMusicList:^(NSArray *datalist) {
        self.datalist = (NSMutableArray *)[NSArray modelArrayWithClass:[HYXiaMiMusicModel class] json:datalist];
        [self.tableView reloadData];
    }];
}

#pragma mark - tableViewDelegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [HYMusicHandleTool shareInstance].musicList.count;
//    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//
//    HYMusicModel *musicModel = [HYMusicHandleTool shareInstance].musicList[indexPath.row];
//    cell.textLabel.text = musicModel.name;
//    cell.detailTextLabel.text = musicModel.singer;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"QQResources" ofType:@"bundle"];
//    NSString *filePath = [[path stringByAppendingPathComponent:@"Images"] stringByAppendingPathComponent:musicModel.icon];
//    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    HYMusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HYMusicListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.currentIndexPath = indexPath;
//    cell.musicModel = self.datalist[indexPath.row];
    cell.localMusicModel = [HYMusicHandleTool shareInstance].musicList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50 * WIDTH_MULTIPLE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    
    HYMusicModel *musicModel = [HYMusicHandleTool shareInstance].musicList[indexPath.row];
    HYMusicPlayerVC *playerVC = [HYMusicPlayerVC new];
    playerVC.musicModel = musicModel;
    [self.navigationController pushViewController:playerVC animated:YES];
    
//    HYXiaMiMusicModel *xiaMiModel = self.datalist[indexPath.row];
//    HYMusicPlayerVC *playerVC = [HYMusicPlayerVC new];
//    playerVC.xiamiMusicModel = xiaMiModel;
//    [self.navigationController pushViewController:playerVC animated:YES];
}

#pragma mark - lazyload
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KAPP_TableView_BgColor;
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
