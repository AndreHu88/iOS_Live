//
//  HYMineViewController.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYMineViewController.h"
#import "HYUserProfileViewController.h"
#import "HYMineHeaderView.h"
#import "HYUserInfoIconCell.h"

@interface HYMineViewController ()

@property (nonatomic,strong) HYMineHeaderView *headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HYTableViewDataSource *dataSource;
@property (nonatomic,strong) HYTableViewDelegate *delegate;
@property (nonatomic,strong) NSMutableArray *dataSetsArray;


@end

@implementation HYMineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNav];
    [self setupTableView];
    [self setupTableViewData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupNav{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self wr_setNavBarBarTintColor:KAPP_WHITE_COLOR];
    [self wr_setNavBarTitleColor:KAPP_BLACK_COLOR];
    [self wr_setNavBarShadowImageHidden:YES];
}

- (void)setupTableView{
    
    self.dataSetsArray = [NSMutableArray array];
    self.delegate = [HYTableViewDelegate new];
    self.dataSource = [HYTableViewDataSource new];
    self.dataSource.dataSource = self.dataSetsArray;
    self.delegate.dataSource = self.dataSetsArray;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView registerClass:[HYUserInfoIconCell class] forCellReuseIdentifier:NSStringFromClass([HYUserInfoIconCell class])];
}

- (void)setupTableViewData{
    
    NSArray *titleArray = @[@"钱包",@"账户",@"等级",@"观看记录"];
    NSArray *imageArray = @[@"user_info_company",@"user_info_help",@"user_info_setup",@"user_info_shop"];
    NSMutableArray *sectionArray = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        
        HYUserInfoIconCellModel *cellModel = [HYUserInfoIconCellModel new];
        cellModel.cellIdientifier = NSStringFromClass([HYUserInfoIconCell class]);
        cellModel.cellHeight = KAdaptedWidth(50);
        cellModel.title = titleArray[i];
        cellModel.iconName = imageArray[i];
        cellModel.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [sectionArray addObject:cellModel];
    }
    
    [self.dataSetsArray addObject:sectionArray];
    [self.tableView reloadData];
}

#pragma mark - action
- (void)headerViewAction{
    
    HYUserProfileViewController *profileVC = [HYUserProfileViewController userProfile];
    [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - setStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)setUserProfileBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        
        HYUserProfileViewController *userProfileVC = [HYUserProfileViewController userProfile];
        [self.navigationController pushViewController:userProfileVC animated:YES];
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
}

#pragma mark - lazyload
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self.delegate;
        _tableView.dataSource = self.dataSource;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _headerView = [[HYMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 200 * WIDTH_MULTIPLE)];
        _headerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewAction)];
        [_headerView addGestureRecognizer:tapGesture];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
