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

@interface HYSuspendTopVC () <UIScrollViewDelegate,UIGestureRecognizerDelegate,SPPageMenuDelegate>

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) HYSuspendBgScrollView *bgScrollView;
@property (nonatomic,strong) UIScrollView *headerBtnScrollView;
@property (nonatomic,strong) UIScrollView *headerBgScrollView;
@property (nonatomic,strong) SPPageMenu *menu;
@property (nonatomic,assign) CGFloat insetTop;                  /// TableView距离顶部的偏移量
@property (nonatomic,strong) UIScrollView *currentScrollView;   /// 当前显示的页面
@property (nonatomic,strong) UIViewController *currentViewController;       /// 当前控制器
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UIScrollView *pageScrollView;
@property (nonatomic,strong) NSMutableDictionary *displayVCCacheDict;
@property (nonatomic,assign) BOOL isHeaderViewInScrollView;     /// headerView是否在ScrollView上
@property (nonatomic,assign) BOOL isHeaderMenuSuspend;          /// buttonMenu是否悬浮

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
    [self _setupPopGetsture];
    
}

- (void)_setupPopGetsture{
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - GestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    // 首先判断gestureRecognizer是不是系统pop手势
    if ([gestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.pageScrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}


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
    _bgScrollView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT);
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
    
    _menu = [SPPageMenu pageMenuWithFrame:_headerBtnScrollView.bounds trackerStyle:SPPageMenuTrackerStyleLine];
    _menu.delegate = self;
    [_menu setItems:_titleArray selectedItemIndex:0];
    _menu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    [_headerBtnScrollView addSubview:_menu];
}

- (void)_setupPageScrollView{
    
    if (_pageScrollView) return;
    _pageScrollView = [[HYSuspendBgScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, _bgScrollView.height)];
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
//    if (self.displayVCCacheDict[@(index)]) return;
    [self _addSubViewControllerWithIndex:index];
    
}

- (void)_addSubViewControllerWithIndex:(NSInteger)index{
    
    UIViewController *viewController = self.suspendVCArrays[index];
    //判断viewController是否已经创建了
    UIViewController *displayViewController = [self.displayVCCacheDict objectForKey:@(index)];
    if (!displayViewController) {
        
        [self addChildViewController:viewController];
        viewController.view.frame = CGRectMake(KSCREEN_WIDTH * index, 0, KSCREEN_WIDTH, self.pageScrollView.height);
        [self.pageScrollView addSubview:viewController.view];
    }
    UIScrollView *scrollView = self.currentScrollView;
    scrollView.delegate = self;
    scrollView.frame = viewController.view.bounds;
    scrollView.contentInset = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
    [viewController didMoveToParentViewController:self];
    
    if (![self.displayVCCacheDict objectForKey:@(index)]) {
        //如果缓存中不存在
        scrollView.contentInset = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_insetTop, 0, 0, 0);
    }
    
    if (self.displayVCCacheDict.count == 0) {
        //第一次加载时，设置inset
        _headerBgScrollView.top = -_insetTop;
        _headerBtnScrollView.top = _headerBgScrollView.bottom;
        [scrollView addSubview:_headerBgScrollView];
        [scrollView addSubview:_headerBtnScrollView];
        [scrollView setContentOffset:CGPointMake(0, -_insetTop) animated:NO];
    }
    else{

        CGFloat buttonScrollViewY = [_headerBtnScrollView.superview convertRect:_headerBtnScrollView.frame toView:self.view].origin.y;
        if (_isHeaderMenuSuspend) {
            //已经悬浮了
            [scrollView setContentOffset:CGPointMake(0, -buttonMenuHeight)];
        }
        else{
            //求出偏移量
            CGFloat currentOffsetY = _headerBgScrollView.height - buttonScrollViewY - _insetTop;
            [scrollView setContentOffset:CGPointMake(0, currentOffsetY)];
        }
        
    }
    
    //把当前的VC加入到缓存字典中
    if (![self.displayVCCacheDict objectForKey:@(index)]) {
        [self.displayVCCacheDict setObject:viewController forKey:@(index)];
    }
}

- (UIScrollView *)currentScrollView{
    
    UIScrollView *scrollView;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(suspendScrollViewWithViewController:pageIndex:)]) {
        
        scrollView = [self.dataSource suspendScrollViewWithViewController:self pageIndex:_currentPageIndex];
    }
    NSAssert(scrollView != nil, @"请设置相应DataSource的数据源方法");
    return scrollView;
}

#pragma mark - SPMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    
//    if (index == 0) {
//        [self.pageScrollView setContentOffset:CGPointMake(0, 0)];
//    }
//    else{
//        [self.pageScrollView setContentOffset:CGPointMake(KSCREEN_WIDTH, 0)];
//    }
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    DLog(@"scrollview:%@,currentOffsetY:%f",NSStringFromClass([scrollView class]),scrollView.contentOffset.y);
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
        _menu.selectedItemIndex = page;
        return;
    };
    
    if (!_isHeaderViewInScrollView) return;
    if (scrollView != self.currentScrollView) return;
    //上下滑动,计算顶部悬浮
    [self _calculateBgScrollViewHeaderSuspend:scrollView];
}

/// 计算bgScrollView的顶部悬停
- (void)_calculateBgScrollViewHeaderSuspend:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= - _insetTop) {
        //下拉ScrollView
        [self.bgScrollView setContentOffset:CGPointMake(0,-_insetTop)];
        self.headerBgScrollView.top = offsetY;
    }
    else{
        self.headerBgScrollView.top = -_insetTop;
    }
    
    //上滑scrollView
    if (offsetY > -buttonMenuHeight) {
        //滑到buttonMenu悬浮在顶部
        _headerBtnScrollView.top = offsetY;
        _headerBgScrollView.top = -_insetTop;
        _isHeaderMenuSuspend = YES;
        [self _adjustButtonMenu:scrollView];
        
    }
    else{
        _isHeaderMenuSuspend = NO;
//        _headerBgScrollView.top = -_insetTop;
        _headerBtnScrollView.top = _headerBgScrollView.bottom;
    }
    
}

- (void)_adjustButtonMenu:(UIScrollView *)scrollView{
    
    if (scrollView.subviews.lastObject != self.headerBgScrollView) {
        //如果buttonMenu不在最顶部，移到最顶部
        [scrollView bringSubviewToFront:self.headerBgScrollView];
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
        DLog(@"_headerBgViewTop:%f",_headerBgScrollView.top);
        
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
        DLog(@"_headerBgViewTop:%f",_headerBgScrollView.top);
        
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
