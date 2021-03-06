//
//  HYEmotionInputView.m
//  live
//
//  Created by Duntech on 2018/6/14.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYEmotionInputView.h"
#import "HYEmotionInputHelper.h"
#import "HYEmotionCollectionViewCell.h"

#define KEmotionRowCount    7.0
#define KEmotionColumn      3
#define KOnePageCount       (KEmotionRowCount * KEmotionColumn - 1)
#define KEmotionWidth       (kScreenWidth - 10 * 2) / KEmotionRowCount
#define KInputViewHeight    (KEmotionWidth * 3 + 10 + 20 + 40)
#define kToolbarHeight      37



@interface HYEmotionInputView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSArray<HYEmotionGroupModel *> *emotionGroup;
@property (nonatomic,strong) NSArray<NSNumber *> *emotionGroupIndexsArray;
@property (nonatomic,strong) NSArray<NSNumber *> *emotionGroupPageCountArray;
@property (nonatomic,strong) NSMutableArray<UIButton *> *toolBtnsArray;
@property (nonatomic,assign) NSInteger emotionTotalPageCount;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *pageControl;

@end

@implementation HYEmotionInputView

+ (instancetype)sharedInputView{
    
    static HYEmotionInputView *inputView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        inputView = [HYEmotionInputView new];
    });
    return inputView;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, KInputViewHeight);
        self.backgroundColor = UIColorHex(f9f9f9);
        [self _setupGroupData];
        [self _setupCollectionView];
        [self _setupToolButton];
        
        _currentPageIndex = NSNotFound;
        //设置collectionView滚动
        [self toolbarButtonClick:self.toolBtnsArray.firstObject];
    }
    return self;
}

#pragma mark - privateMethod
- (void)_setupGroupData{
    
    _emotionGroup = [HYEmotionInputHelper emotionGroups];
    
    NSMutableArray *emotionIndexsArray = [NSMutableArray array];
    NSInteger indexCount = 0;
    for (HYEmotionGroupModel *groupModel in _emotionGroup) {
        [emotionIndexsArray addObject:@(indexCount)];
        NSInteger count = ceil(groupModel.emotions.count / KOnePageCount);
        indexCount += count;
    }
    _emotionGroupIndexsArray = emotionIndexsArray;
    
    NSMutableArray *emotionCountArray = [NSMutableArray array];
    _emotionTotalPageCount = 0;
    for (HYEmotionGroupModel *groupModel in _emotionGroup) {
        
        NSInteger pageCount = ceil(groupModel.emotions.count / (float)KOnePageCount);
        if (pageCount == 0) pageCount = 1;
        [emotionCountArray addObject:@(pageCount)];
        _emotionTotalPageCount += pageCount;
    }
    _emotionGroupPageCountArray = emotionCountArray;
}

- (void)_setupCollectionView{
    
    
    CGFloat itemWidth = KEmotionWidth;
    itemWidth = CGFloatPixelRound(itemWidth);
    CGFloat padding = (kScreenWidth - 7 * itemWidth) / 2.0;
    CGFloat paddingLeft = CGFloatPixelRound(padding);
    CGFloat paddingRight = kScreenWidth - paddingLeft - itemWidth * 7;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, itemWidth * 3) collectionViewLayout:layout];
    [_collectionView registerClass:[HYEmotionCollectionViewCell class] forCellWithReuseIdentifier:@"HYEmotionCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.top = 5;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    [self addSubview:_collectionView];
    
    _pageControl = [UIView new];
    _pageControl.size = CGSizeMake(kScreenWidth, 20);
    _pageControl.top = _collectionView.bottom + 5;
    [self addSubview:_pageControl];
}

- (void)_setupToolButton{
    
    UIView *toolView = [UIView new];
    toolView.size = CGSizeMake(KSCREEN_WIDTH, kToolbarHeight);
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[HYEmotionInputHelper emotionImageNamed:@"compose_emotion_table_right_normal"]];
    bgImageView.frame = toolView.bounds;
    [toolView addSubview:bgImageView];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.size = toolView.size;
    scrollView.contentSize = toolView.size;
    [toolView addSubview:scrollView];
    
    _toolBtnsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _emotionGroupIndexsArray.count; i++) {
        
        HYEmotionGroupModel *groupModel = self.emotionGroup[i];
        UIButton *btn = [self _createToolBtn];
        btn.tag = i;
        [btn setTitle:groupModel.group_name_cn forState:UIControlStateNormal];
        btn.left = KSCREEN_WIDTH / _emotionGroupIndexsArray.count * i;
        
        [scrollView addSubview:btn];
        [_toolBtnsArray addObject:btn];
    }
    
    toolView.bottom = self.height;
    [self addSubview:toolView];
    
}

- (UIButton *)_createToolBtn{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(KSCREEN_WIDTH / _emotionGroupIndexsArray.count, kToolbarHeight);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(5D5C5A) forState:UIControlStateSelected];
    
    UIImage *image = [UIImage imageNamed:@"compose_emotion_table_left_normal"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage *selectImage = [UIImage imageNamed:@"compose_emotion_table_left_selected"];
    selectImage = [selectImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:selectImage forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(toolbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)toolbarButtonClick:(UIButton *)sender{
    
    NSInteger pageIndex = sender.tag;
    NSInteger page = _emotionGroupIndexsArray[pageIndex].integerValue;
    CGRect rect = CGRectMake(page * _collectionView.width, 0, _collectionView.width, _collectionView.height);
    [_collectionView scrollRectToVisible:rect animated:NO];
    [self scrollViewDidScroll:_collectionView];
}

#pragma mark - tool
- (HYEmotionModel *)_getEmotionModelWithIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    HYEmotionModel *emotionModel;
    for (NSInteger i = self.emotionGroupIndexsArray.count - 1; i >= 0; i--) {

        NSInteger pageIndex = self.emotionGroupIndexsArray[i].integerValue;
        if (section >= pageIndex) {
            
            NSInteger currentGroupPageIndex = section - _emotionGroupIndexsArray[i].integerValue;
            HYEmotionGroupModel *groupModel = self.emotionGroup[i];
            //算出当前的位置
            NSInteger currentIndexItem = (KOnePageCount + 1) * currentGroupPageIndex + indexPath.row;
            //减去删除按钮的个数
            NSInteger deleteBtnCount = currentIndexItem / (KOnePageCount + 1);
            NSInteger emotionIndex = currentIndexItem - deleteBtnCount;
            if (emotionIndex < groupModel.emotions.count) {
                emotionModel = groupModel.emotions[emotionIndex];
            }
        }
    }
    return emotionModel;
}

#pragma mark - CollectionViewDelegate DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.emotionTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return KOnePageCount + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYEmotionCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item == KOnePageCount) {
        cell.isDelete = YES;
        cell.emotionModel = nil;
    }
    else{
        cell.isDelete = NO;
        cell.emotionModel = [self _getEmotionModelWithIndexPath:indexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYEmotionCollectionViewCell *cell = (HYEmotionCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [JRToast showWithText:cell.emotionModel.chs duration:2];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = round(scrollView.contentOffset.x / scrollView.width);
    if (page < 0) page = 0;
    else if (page >= _emotionTotalPageCount) page = _emotionTotalPageCount - 1;
    if (page == _currentPageIndex) return;
    _currentPageIndex = page;
    
    NSInteger currentGroupIndex = 0, currentGroupPageCount = 0, currentGroupPageIndex = 0;
    for (NSInteger i = _emotionGroupIndexsArray.count - 1; i >= 0 ; i--) {
        
        if (page >= _emotionGroupIndexsArray[i].integerValue) {
            
            currentGroupIndex = i;
            currentGroupPageCount = _emotionGroupPageCountArray[i].integerValue;
            currentGroupPageIndex = page - _emotionGroupIndexsArray[i].integerValue;
            break;
        }
    }
    
    //绘制pageControl
    [_pageControl.layer removeAllSublayers];
    
    CGFloat padding = 5, width = 6, height = 2;
    CGFloat pageControlWidth = (width + 2 * padding) * currentGroupPageCount;
    for (NSInteger i = 0; i < currentGroupPageCount; i++) {
        
        CALayer *layer = [CALayer layer];
        layer.size = CGSizeMake(width, height);
        layer.cornerRadius = 1;
        if (i == currentGroupPageIndex) {
            layer.backgroundColor = UIColorHex(fd8225).CGColor;
        }
        else{
            layer.backgroundColor = UIColorHex(dedede).CGColor;
        }
        layer.centerY = _pageControl.height / 2;
        layer.left = (_pageControl.width - pageControlWidth) / 2 + i * (width + padding * 2) + padding;
        [_pageControl.layer addSublayer:layer];
    }
    
    [_toolBtnsArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
       
        btn.selected = (idx == currentGroupIndex);
    }];
}

@end
