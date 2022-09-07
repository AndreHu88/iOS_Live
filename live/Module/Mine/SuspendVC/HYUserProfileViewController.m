//
//  HYUserProfileViewController.m
//  live
//
//  Created by Duntech on 2018/7/20.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYUserProfileViewController.h"
#import "HYMyFollowViewController.h"
#import "HYMyAlbumViewController.h"

@interface HYUserProfileViewController () <HYSuspendViewControllerDataSource,SDCycleScrollViewDelegate>

@end

@implementation HYUserProfileViewController

+ (instancetype)userProfile{
    
    NSArray *titleArray = @[@"关注",@"相册"];
    NSArray *vcArray = [self pageVCArray];
    HYUserProfileViewController *userProfileVC = (HYUserProfileViewController *)[HYUserProfileViewController suspendTopWithTitleArray:titleArray suspendViewControllers:vcArray];
    userProfileVC.dataSource = userProfileVC;
    
    NSArray *bannerUrlArray = @[@"https://img.zcool.cn/community/014b1f5b553ff5a80121ade05fe9a8.jpg",@"https://img.zcool.cn/community/0132465b54dbd6a8012036be578293.png",@"https://img.zcool.cn/community/014c785b51ecb7a80121ade0bea244.jpg"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 200) imageURLStringsGroup:bannerUrlArray];
    cycleScrollView.delegate = userProfileVC;
    userProfileVC.headerView = cycleScrollView;
    return userProfileVC;
}

+ (NSArray *)pageVCArray{
    
    HYMyFollowViewController *myFollowVC = [HYMyFollowViewController new];
    HYMyAlbumViewController *myAlbumVC = [HYMyAlbumViewController new];
    return @[myFollowVC,myAlbumVC];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupNav];
}

- (void)setupNav{
    
    [super setupNav];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self wr_setNavBarBarTintColor:KAPP_THEME_COLOR];
    [self wr_setNavBarTitleColor:KAPP_THEME_COLOR];
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarShadowImageHidden:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - SDCycleViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    
}

#pragma mark - SuspendVCDataSource
- (UIScrollView *)suspendScrollViewWithViewController:(HYSuspendTopVC *)viewController pageIndex:(NSInteger)pageIndex{
    
    UIScrollView *scrollView;
    if (pageIndex == 0) {
        
        HYMyFollowViewController *followVC = viewController.suspendVCArrays[pageIndex];
        scrollView = [followVC tableView];
    }
    if (pageIndex == 1) {
        
        HYMyAlbumViewController *albumVC = viewController.suspendVCArrays[pageIndex];
        scrollView = [albumVC collectionView];
    }
    return scrollView;
}

#pragma mark - setStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
