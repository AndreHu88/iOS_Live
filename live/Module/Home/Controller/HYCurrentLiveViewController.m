//
//  HYCurrentLiveViewController.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYCurrentLiveViewController.h"
#import "HYLiveControllerVC.h"
#import "HYLiveScrollView.h"
#import "HYLiveViewModel.h"

@interface HYCurrentLiveViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) HYLiveScrollView  *scrollView;
@property (nonatomic,strong) HYLiveViewModel *viewModel;

@end

@implementation HYCurrentLiveViewController

- (void)loadView{
    
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self bindViewModel];
    [self addChildVC];
}

- (void)bindViewModel{
    
    self.viewModel = [[HYLiveViewModel alloc] init];
    [self.viewModel setWithViewModel:self.liveModel];
    self.scrollView.viewModel = self.viewModel;
    
    [_viewModel.closeLiveSubject subscribeNext:^(id x) {
       
        [self.navigationController popViewControllerAnimated:YES];
        if ([_viewModel.player isPlaying] || [_viewModel.player isPreparedToPlay]) {
            
            [_viewModel.player shutdown];
        }
    }];
}


- (void)addChildVC{
    
    HYLiveControllerVC *liveControllerVC = [HYLiveControllerVC new];
    liveControllerVC.viewModel = self.viewModel;
    [self addChildViewController:liveControllerVC];
    liveControllerVC.view.frame = CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, KSCREEN_HEIGHT);
    [self.view addSubview:liveControllerVC.view];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - lazyload
- (HYLiveScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[HYLiveScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.viewModel = self.viewModel;
        _scrollView.currentIndex = self.currentIndex;
        _scrollView.currentLiveModel = self.liveModel;
        _scrollView.modelList = self.modelList;
    }
    return _scrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
