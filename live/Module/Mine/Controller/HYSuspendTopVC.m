//
//  HYSuspendTopVC.m
//  live
//
//  Created by Duntech on 2018/7/18.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYSuspendTopVC.h"
#import "HYSuspendBgScrollView.h"

@interface HYSuspendTopVC () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *suspendVCArrays;
@property (nonatomic,strong) HYSuspendBgScrollView *bgScrollView;
@property (nonatomic,strong) UIScrollView *headerBtnScrollView;
@property (nonatomic,strong) UIScrollView *headerBgScrollView;
/// TableView距离顶部的偏移量
@property (nonatomic,assign) CGFloat insetTop;
/// 当前显示的页面
@property (nonatomic,strong) UIScrollView *currentScrollView;
/// 当前控制器
@property (nonatomic,strong) UIViewController *currentViewController;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UIScrollView *pageScrollView;
@property (nonatomic,strong) NSMutableDictionary *displayVCCacheDict;

@end

static CGFloat buttonMenuHeight  = 44.f;

@implementation HYSuspendTopVC

+ (instancetype)suspendTopWithTitleArray:(NSArray *)titleArray suspendViewControllers:(NSArray *)viewControllers{
    
    HYSuspendTopVC *suspendVC = [HYSuspendTopVC new];
    suspendVC.titleArray = titleArray.mutableCopy;
    suspendVC.suspendVCArrays = viewControllers.mutableCopy;
    return suspendVC;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _checkParameters];
        _displayVCCacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _setupSubviews];
}

#pragma mark - public

#pragma mark - private
- (void)_checkParameters{
    
#ifdef DEBUG
    NSAssert(self.suspendVCArrays.count > 0, @"viewControllers not null");
    NSAssert(self.titleArray.count > 0, @"titleArray must be not null");
    NSAssert(self.suspendVCArrays.count == self.titleArray.count, @"titlesArray count must equal viewControllersArray");
#endif
    
}

- (void)_setupSubviews{
    
    [self _setupBgScrollView];
    [self _setupHeaderView];
    [self _setupPageScrollView];
    _insetTop = _headerBgScrollView.height + _headerBtnScrollView.height;

}

- (void)_setupBgScrollView{
    
    if (_bgScrollView) return;
    _bgScrollView = [HYSuspendBgScrollView new];
    _bgScrollView.showsVerticalScrollIndicator = YES;
    _bgScrollView.showsHorizontalScrollIndicator = YES;
    _bgScrollView.delegate = self;
    _bgScrollView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_bgScrollView];
    _bgScrollView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - KNavTotal_HEIGHT);
    _bgScrollView.contentSize = CGSizeMake(KSCREEN_WIDTH, self.bgScrollView.height);
}

- (void)_setupHeaderView{
    
    if(_headerBgScrollView) return;
    _headerBgScrollView = [[UIScrollView alloc] initWithFrame:self.headerView.bounds];
    [self.view addSubview:_headerBgScrollView];
    
    if (_headerBtnScrollView) return;
    _headerBtnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerView.height, KSCREEN_WIDTH, buttonMenuHeight)];
    [self.view addSubview:_headerBtnScrollView];
}

- (void)_setupPageScrollView{
    
    if (_pageScrollView) return;
    _pageScrollView = [[HYSuspendBgScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - KNavTotal_HEIGHT)];
    _pageScrollView.contentSize = CGSizeMake(KSCREEN_WIDTH * self.suspendVCArrays.count, _pageScrollView.height);
    _pageScrollView.delegate = self;
    _pageScrollView.showsVerticalScrollIndicator = NO;
    _pageScrollView.showsHorizontalScrollIndicator = NO;
    _pageScrollView.bounces = NO;
    _pageScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageScrollView];
}

- (void)_initSubViewControllersWithIndex:(NSInteger)index{
    
    self.currentViewController = self.suspendVCArrays[index];
    self.currentPageIndex = index;
    if (self.displayVCCacheDict[@(index)]) return;
    [self _addSubViewControllerWithIndex:index];
    
}

- (void)_addSubViewControllerWithIndex:(NSInteger)index{
    
    UIViewController *viewController = self.suspendVCArrays[index];
    [self addChildViewController:viewController];
    viewController.view.frame = CGRectMake(KSCREEN_WIDTH * index, 0, KSCREEN_WIDTH, self.pageScrollView.height);
    UIScrollView *scrollView = self.currentScrollView;
    scrollView.frame = viewController.view.bounds;
    scrollView.contentInset = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
    if (self.displayVCCacheDict.count == 0) {
        //第一次加载时，设置inset
        _headerBgScrollView.top = _insetTop;
        _headerBtnScrollView.top = _headerBtnScrollView.bottom;
        [scrollView addSubview:_headerBgScrollView];
        [scrollView addSubview:_headerBtnScrollView];
        [scrollView setContentOffset:CGPointMake(0, -_insetTop) animated:NO];
    }
    else{
        //当前已经有偏移量了，直接计算
        CGFloat buttonScrollViewY = [_headerBtnScrollView.superview convertRect:_headerBtnScrollView.frame toView:self.view].origin.y;
        CGFloat scrollMenuViewOffsetY = _headerView.height - buttonScrollViewY;
        scrollMenuViewOffsetY = -_insetTop + scrollMenuViewOffsetY;
        [scrollView setContentOffset:CGPointMake(0, scrollMenuViewOffsetY) animated:NO];
        
    }
    
    //把当前的VC加入到缓存字典中
    if (![self.displayVCCacheDict objectForKey:@(index)]) {
        [self.displayVCCacheDict setObject:viewController forKey:@(index)];
    }
}

- (UIScrollView *)currentScrollView{
    
    UIScrollView *scrollView;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(suspendScrollViewWithViewController:pageIndex:)]) {
        
        UIViewController *vc = self.suspendVCArrays[self.currentPageIndex];
        scrollView = [self.dataSource suspendScrollViewWithViewController:vc pageIndex:_pageIndex];
    }
    NSAssert(scrollView != nil, @"请设置相应DataSource的数据源方法");
    return scrollView;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgScrollView) {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
