//
//  HYLiveScrollView.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveScrollView.h"
#import "HYLiveCollectionViewCell.h"

@interface HYLiveScrollView() <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/** 上一个 */
@property (nonatomic,strong) UICollectionView *previousCollectView;
/** 当前的 */
@property (nonatomic,strong) UICollectionView *currentCollectView;
/** 下一个 */
@property (nonatomic,strong) UICollectionView *nextCollectView;
/** layout */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/** 上一个model */
@property (nonatomic,strong) HYHotLiveModel *previousModel;
/** 下一个model */
@property (nonatomic,strong) HYHotLiveModel *nextModel;
/** 记录上一次的偏移量 */
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation HYLiveScrollView

static NSString *cellID = @"HYLiveCollectionCell";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        [self configScrollView];
        [self setupSubviews];
        self.lastContentOffset = KSCREEN_HEIGHT;
    }
    
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.previousCollectView];
    [self addSubview:self.currentCollectView];
    [self addSubview:self.nextCollectView];
}

#pragma mark - collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (collectionView == _previousCollectView) {
        
        cell.currentLiveModel = self.previousModel;
    }
    else if (collectionView == _currentCollectView){
        
        
        cell.currentLiveModel = self.currentLiveModel;
        [self.viewModel setWithViewModel:self.currentLiveModel];
        [cell setWithViewModel:self.viewModel];
    }
    else{
        
        cell.currentLiveModel = self.nextModel;
    }
    
    return cell;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ((_currentIndex < 1 && offsetY < KSCREEN_HEIGHT) || (_currentIndex > _modelList.count - 1 && offsetY > KSCREEN_HEIGHT)) {
        
        return;
    }
    
    if (scrollView == self) {
        
        if (offsetY < KSCREEN_HEIGHT) {
            
            //下滑，中间的数据变为下一个 上面的数据变为中间，需要重新获取上一个数据
            self.previousModel = self.modelList[_currentIndex - 1];
            _currentIndex -= 1;
            self.currentLiveModel = self.modelList[_currentIndex];
            self.nextModel = self.modelList[_currentIndex + 1];
            
        }
        else if (offsetY > KSCREEN_HEIGHT){
            
            //上滑  将当前model变为上一个，下一个model变为中间的，重新获取下一个model
            _currentIndex += 1;
            self.previousModel = _currentLiveModel;
            self.currentLiveModel = self.modelList[_currentIndex];
            self.nextModel = self.modelList[_currentIndex + 1];
        }
        
        if (fabs(offsetY - self.lastContentOffset) < 200 && fabs(offsetY - self.lastContentOffset) != 0) {
            
            return;
        }
        
        self.lastContentOffset = offsetY;

        [_currentCollectView reloadData];
        [scrollView setContentOffset:CGPointMake(0, KSCREEN_HEIGHT) animated:NO];
        [_previousCollectView reloadData];
        [_nextCollectView reloadData];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ((_currentIndex < 1 && offsetY < KSCREEN_HEIGHT)) {
        
        scrollView.scrollEnabled = NO;
        return;
    }
    else if ((_currentIndex > _modelList.count - 1 && offsetY > KSCREEN_HEIGHT)){
        
        scrollView.scrollEnabled = NO;
        return;
    }
    else if ((self.viewModel.isScrollViewCanScroll == NO) && _viewModel){
        
        scrollView.scrollEnabled = YES;
        return;
    }
    else{
        scrollView.scrollEnabled = YES;
    }
    
        scrollView.scrollEnabled = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    self.lastContentOffset = offsetY;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.viewModel.isScrollViewCanScroll = YES;
    self.scrollEnabled = YES;
}

- (void)configScrollView{
    
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    self.contentSize = CGSizeMake(KSCREEN_WIDTH, KSCREEN_HEIGHT * 3);
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self setContentOffset:CGPointMake(0, KSCREEN_HEIGHT) animated:NO];
}

#pragma mark - lazyload
- (UICollectionView *)previousCollectView{
    
    if (!_previousCollectView) {
        
        _previousCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _previousCollectView.dataSource = self;
        _previousCollectView.delegate = self;
        _previousCollectView.backgroundColor = [UIColor whiteColor];
        [_previousCollectView registerClass:[HYLiveCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        if (@available(iOS 11.0, *)) {
            _previousCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _previousCollectView;
}

- (UICollectionView *)currentCollectView{
    
    if (!_currentCollectView) {
        
        _currentCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, KSCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _currentCollectView.dataSource = self;
        _currentCollectView.delegate = self;
        _currentCollectView.backgroundColor = [UIColor whiteColor];
        [_currentCollectView registerClass:[HYLiveCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        if (@available(iOS 11.0, *)) {
            _currentCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _currentCollectView;
}

- (UICollectionView *)nextCollectView{
    
    if (!_nextCollectView) {
        
        _nextCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT * 2, KSCREEN_WIDTH, KSCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _nextCollectView.dataSource = self;
        _nextCollectView.delegate = self;
        _nextCollectView.backgroundColor = [UIColor whiteColor];
        [_nextCollectView registerClass:[HYLiveCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        if (@available(iOS 11.0, *)) {
            _nextCollectView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _nextCollectView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0.0;
        _flowLayout.minimumInteritemSpacing = 0.0;
        _flowLayout.itemSize = CGSizeMake(KSCREEN_WIDTH, KSCREEN_HEIGHT);
    }
    return _flowLayout;
}

- (HYHotLiveModel *)previousModel{
    
    if (!_previousModel) {
        
        _previousModel = (_currentIndex < 1) ? _currentLiveModel : self.modelList[_currentIndex - 1];
    }
    return _previousModel;
}

- (HYHotLiveModel *)nextModel{
    
    if (!_nextModel) {
        
        _nextModel = _currentIndex > _modelList.count - 1 ? _currentLiveModel : self.modelList[_currentIndex + 1];
    }
    return _nextModel;
}


@end
