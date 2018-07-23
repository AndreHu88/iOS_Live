//
//  HYSuspendTopVC.m
//  live
//
//  Created by Duntech on 2018/7/18.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYSuspendTopVC.h"
#import "HYSuspendBgScrollView.h"
#import <SPPageMenu.h>

@interface HYSuspendTopVC () <UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) HYSuspendBgScrollView *bgScrollView;
@property (nonatomic,strong) UIScrollView *headerBtnScrollView;
@property (nonatomic,strong) UIScrollView *headerBgScrollView;
@property (nonatomic,assign) CGFloat insetTop;                  /// TableView距离顶部的偏移量
@property (nonatomic,strong) UIScrollView *currentScrollView;   /// 当前显示的页面
@property (nonatomic,strong) UIViewController *currentViewController;       /// 当前控制器
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UIScrollView *pageScrollView;
@property (nonatomic,strong) NSMutableDictionary *displayVCCacheDict;
@property (nonatomic,assign) BOOL isHeaderViewInScrollView;     /// headerView是否在ScrollView上

@end

static CGFloat buttonMenuHeight  = 44.f;

@implementation HYSuspendTopVC

+ (instancetype)suspendTopWithTitleArray:(NSArray *)titleArray suspendViewControllers:(NSArray *)viewControllers{
    
    HYSuspendTopVC *suspendVC = [self new];
    suspendVC.titleArray = titleArray.mutableCopy;
    suspendVC.suspendVCArrays = viewControllers.mutableCopy;
    return suspendVC;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _displayVCCacheDict = [NSMutableDictionary dictionary];
        _isHeaderViewInScrollView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self _checkParameters];
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
    [self _initSubViewControllersWithIndex:0];
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
    _bgScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_bgScrollView];
    _bgScrollView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - KNavTotal_HEIGHT);
    _bgScrollView.contentSize = CGSizeMake(KSCREEN_WIDTH, self.bgScrollView.height);
}

- (void)_setupHeaderView{
    
    if(_headerBgScrollView) return;
    _headerBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, _headerView.height)];
    [_headerBgScrollView addSubview:self.headerView];
    [self.bgScrollView addSubview:_headerBgScrollView];
    
    if (_headerBtnScrollView) return;
    _headerBtnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headerView.height, KSCREEN_WIDTH, buttonMenuHeight)];
    [self.view addSubview:_headerBtnScrollView];
    SPPageMenu *menu = [SPPageMenu pageMenuWithFrame:_headerBtnScrollView.bounds trackerStyle:SPPageMenuTrackerStyleLine];
    [menu setItems:_titleArray selectedItemIndex:0];
    [_headerBtnScrollView addSubview:menu];
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
    _pageScrollView.pagingEnabled = YES;
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
    [self.pageScrollView addSubview:viewController.view];
    UIScrollView *scrollView = self.currentScrollView;
    scrollView.delegate = self;
    scrollView.frame = viewController.view.bounds;
    scrollView.contentInset = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
    [viewController didMoveToParentViewController:self];
    
    if (self.displayVCCacheDict.count == 0) {
        //第一次加载时，设置inset
        _headerBgScrollView.top = -_insetTop;
        _headerBtnScrollView.top = _headerBgScrollView.bottom;
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
        
        scrollView = [self.dataSource suspendScrollViewWithViewController:self pageIndex:_pageIndex];
    }
    NSAssert(scrollView != nil, @"请设置相应DataSource的数据源方法");
    return scrollView;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgScrollView) {
        
        return;
    }
    
    if (scrollView == self.pageScrollView) {
        //左右滑动
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger page =  round(offsetX / KSCREEN_WIDTH);
        /// 在滑动时将顶部headerView 放置到View上
        [self _replaceHeaderViewFromScrollViewToView];
        [self _initSubViewControllersWithIndex:page];
        return;
    };
    
    if (!_isHeaderViewInScrollView) return;
    if (scrollView != self.currentScrollView) return;
    //上下滑动,计算顶部悬浮
    [self _calculateBgScrollViewHeaderSuspend];
}

/// 计算bgScrollView的顶部悬停
- (void)_calculateBgScrollViewHeaderSuspend{
    
    CGFloat offsetY = self.bgScrollView.contentOffset.y;
    if (offsetY >= _insetTop) {
        [self.bgScrollView setContentOffset:CGPointMake(0, _insetTop)];
    }
    else{
        UIScrollView *scrollView = self.currentScrollView;
        if (scrollView.contentOffset.y > 0) {
            [self.currentScrollView setContentOffset:CGPointMake(0, _insetTop)];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    /// 滑动结束时在将headerView 放置到ScrollView上
    [self _replaceHeaderViewFromViewToScrollView];
}

/// 将headerView从ScrollView放置到View上
- (void)_replaceHeaderViewFromScrollViewToView{
    
    if (_isHeaderViewInScrollView) {
        
        //计算bgScrollView上的headerView相对pageScrollView的位置
        //[viewB convertRect:viewC.frame toView:viewA];     //计算viewB上的viewC相对于viewA的frame
        CGFloat headerViewTop = [_headerBgScrollView.superview convertRect:_headerBgScrollView.frame toView:self.pageScrollView].origin.y;
        CGFloat buttonMenuTop = [_headerBtnScrollView.superview convertRect:_headerBtnScrollView.frame toView:self.pageScrollView].origin.y;
        
        [_headerBgScrollView removeFromSuperview];
        [_headerBtnScrollView removeFromSuperview];
        
        _headerBgScrollView.top = headerViewTop;
        _headerBtnScrollView.top = buttonMenuTop;
        
        [self.view addSubview:_headerBgScrollView];
        [self.view addSubview:_headerBtnScrollView];
        
        _isHeaderViewInScrollView = NO;
    }
}

/// 将headerView从view上放置到ScrollView上
- (void)_replaceHeaderViewFromViewToScrollView{
    
    if (!_isHeaderViewInScrollView) {
        
        //计算bgScrollView上的headerView相对pageScrollView的位置
        UIScrollView *scrollView = self.currentScrollView;
        CGFloat headerViewY = [_headerBgScrollView.superview convertRect:_headerBgScrollView.frame toView:scrollView].origin.y;
        CGFloat buttonMenuY = [_headerBtnScrollView.superview convertRect:_headerBtnScrollView.frame toView:scrollView].origin.y;
        
        [_headerBgScrollView removeFromSuperview];
        [_headerBtnScrollView removeFromSuperview];
        
        _headerBgScrollView.top = headerViewY;
        _headerBtnScrollView.top = buttonMenuY;
        
        [scrollView addSubview:self.headerBgScrollView];
        [scrollView addSubview:self.headerBtnScrollView];
        
        _isHeaderViewInScrollView = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
