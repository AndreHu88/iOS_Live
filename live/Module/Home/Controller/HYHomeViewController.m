  //
//  HYHomeViewController.m
//  live
//
//  Created by Jack on 2017/11/22.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYHomeNavTitleView.h"
#import "HYHotLiveViewController.h"
#import "HYSmallVideoViewController.h"
#import "HYEatChickenViewController.h"

@interface HYHomeViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) HYHomeNavTitleView *titleView;
@property (nonatomic,strong) UIScrollView  *scrollView;
@property (nonatomic,strong) HYSmallVideoViewController *smallVideoVC;
@property (nonatomic,strong) HYEatChickenViewController *checkenVC;

@end

@implementation HYHomeViewController

- (void)loadView{
    
    //将页面的View替换为scrollView
    self.view = self.scrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setStatusBarBackgroundColor:KAPP_Clear_COLOR];
    [self setupChildVC];
    [self addTitleView];
}

- (void)setupChildVC{
    
    //执行addChildViewController时 不用执行vc的viewdidload,只有设置View的frame时会走viewdidload
    HYSmallVideoViewController *smallVideoVC = [HYSmallVideoViewController new];
    [self addChildViewController:smallVideoVC];
    
    HYHotLiveViewController *hotLiveVC = [HYHotLiveViewController new];
    [self addChildViewController:hotLiveVC];
    hotLiveVC.view.frame = self.view.bounds;
    hotLiveVC.view.left = KSCREEN_WIDTH;
    hotLiveVC.view.height = KSCREEN_HEIGHT - 49;
    [self.scrollView addSubview:hotLiveVC.view];
    
    HYEatChickenViewController *eatChickenVC = [HYEatChickenViewController new];
    [self addChildViewController:eatChickenVC];
    
    self.smallVideoVC = smallVideoVC;
    self.checkenVC = eatChickenVC;
    
}

#pragma mark - action
- (void)searchAction{
    
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX =  self.scrollView.contentOffset.x;
    NSInteger page =  round(offsetX / KSCREEN_WIDTH);
    
    if (page == 0) {
        
        self.smallVideoVC.view.frame = self.view.bounds;
        self.smallVideoVC.view.left = 0;
        self.smallVideoVC.view.height = KSCREEN_HEIGHT - 49;
        [self.scrollView addSubview:self.smallVideoVC.view];
    }
    
    if (page == 2) {
        
        self.checkenVC.view.frame = self.view.bounds;
        self.checkenVC.view.left = KSCREEN_WIDTH * 2;
        self.checkenVC.view.height = KSCREEN_HEIGHT - 49;
        [self.scrollView addSubview:self.checkenVC.view];
    }
   
    self.titleView.selectIndex = page;
}

#pragma mark - lazyload
- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.contentSize = CGSizeMake(KSCREEN_WIDTH * 3, 0);
        _scrollView.contentOffset = CGPointMake(KSCREEN_WIDTH, 0);
        _scrollView.backgroundColor = [UIColor whiteColor];
        // 去掉滚动条
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置分页
        _scrollView.pagingEnabled = YES;
        // 设置代理
        _scrollView.delegate = self;
        // 去掉弹簧效果
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (void)addTitleView{
    
    self.titleView = [[HYHomeNavTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.titleView.centerX = self.view.centerX;
    [self.navigationController.navigationBar addSubview:self.titleView];

    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"global_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_more"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    self.navigationItem.leftBarButtonItem = searchBtn;
    self.navigationItem.rightBarButtonItem = moreBtn;
    
    __weak typeof (self)weakSelf = self;
    self.titleView.titleBtnSelectBlock = ^(NSInteger index) {
      
        [weakSelf.scrollView setContentOffset:CGPointMake(KSCREEN_WIDTH * index, 0) animated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
