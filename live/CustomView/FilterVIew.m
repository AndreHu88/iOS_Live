//
//  FilterVIew.m
//  PopView
//
//  Created by LEMO on 2017/2/20.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "FilterVIew.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGTH [UIScreen mainScreen].bounds.size.height
#define margin 10

@interface MyCollectionHeaderView : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation MyCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //计算文本的高度
        NSString *str = @"智能排序";
        CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH / 2, size.height)];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end

@interface FilterModel : NSObject

@property (nonatomic,assign) BOOL  isSelect;
@property (nonatomic,copy)   NSString *string;

@end


@implementation FilterModel

@end


@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) FilterModel *model;

@end

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        CGFloat width = (SCREEN_WIDTH - 4*margin - 40) / 3;
        CGFloat height = 32;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _titleLabel.layer.cornerRadius = 4.0f;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setModel:(FilterModel *)model{
    
    _titleLabel.text = model.string;
    if (model.isSelect) {
        _titleLabel.textColor = [UIColor colorWithRed:(126 / 255.0) green:(206 / 255.0) blue:(244 / 255.0) alpha:1];
    }
    else{
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    _model = model;
    
}

@end


@interface FilterVIew()

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,copy)   NSArray *sexArray;
@property (nonatomic,copy)   NSArray *ageArray;
@property (nonatomic,copy)   NSArray *capacityArray;
@property (nonatomic,copy)   NSArray *titleArray;

@property (nonatomic,strong) UIButton *confirBtn;

@property (nonatomic,copy) NSString *selectStr1;
@property (nonatomic,copy) NSString *selectStr2;
@property (nonatomic,copy) NSString *selectStr3;

@end

@implementation FilterVIew

#pragma mark  重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        /**初始化数据*/
        _sexArray = @[@"不限", @"女生", @"男生"];
        _ageArray = @[@"不限", @"20岁以下", @"20-25岁", @"25-30岁", @"30-35岁", @"35岁以上"];
        _capacityArray = @[@"全选", @"离我最近", @"实名认证"];
        _titleArray = @[@"性别", @"年龄", @"智能排序"];
        
        /**初始化indexStr*/
        _selectStr1 = _sexArray[0];
        _selectStr2 = _ageArray[0];
        _selectStr3 = _capacityArray[0];
        
        //collectionView的设置
        [self addSubview:self.collectionView];
        /**将数据放入dataArray*/
        [self reloadData];
        
    }
    return self;
}

#pragma mark   CollectionViewDelegate DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _dataArray.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //判断是头视图还是尾视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MyCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        headerView.titleLabel.text = _titleArray[indexPath.section];
        return headerView;
    }
    else{
        return nil;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"identifier";
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSArray *array = self.dataArray[indexPath.section];
    FilterModel *model = array[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = _dataArray[indexPath.section];
    FilterModel *model = array[indexPath.row];
    for (FilterModel *model1 in array) {
        model1.isSelect = NO;
        if (indexPath.section == 0) {
            _selectStr1 = model.string;
        }
        else if (indexPath.section == 1){
            _selectStr2 = model.string;
        }
        else{
            _selectStr3 = model.string;
        }
    }
    model.isSelect = YES;
    [collectionView reloadData];
    
    
}

#pragma mark   加载数据
- (void)reloadData{
    
    //性别数组
    NSMutableArray *sex = [NSMutableArray array];
    for (NSString *str in _sexArray) {
        FilterModel *model = [[FilterModel alloc]init];
        model.string = str;
        model.isSelect = NO;
        if ([model.string isEqualToString:_sexArray[0]]) {
            model.isSelect = YES;
        }
        [sex addObject:model];
    }
    
    //年龄数组
    NSMutableArray *age = [NSMutableArray array];
    for (NSString *str in _ageArray) {
        FilterModel *model = [[FilterModel alloc]init];
        model.string = str;
        model.isSelect = NO;
        if ([model.string isEqualToString:_ageArray[0]]) {
            model.isSelect = YES;
        }
        [age addObject:model];
    }
    
    //capacity数组
    NSMutableArray *capacity = [NSMutableArray array];
    for (NSString * str in _capacityArray) {
        FilterModel *model = [[FilterModel alloc]init];
        model.string = str;
        model.isSelect = NO;
        if ([model.string isEqualToString:_capacityArray[0]]) {
            model.isSelect = YES;
        }
        [capacity addObject:model];
    }
    
    NSMutableArray *title = [NSMutableArray array];
    for (NSString *str in _titleArray) {
        FilterModel *model = [[FilterModel alloc]init];
        model.string = str;
        model.isSelect = NO;
        [title addObject:model];
    }
    
    [self.dataArray addObject:sex];
    [self.dataArray addObject:age];
    [self.dataArray addObject:capacity];

}

#pragma mark  确认按钮点击方法
- (void)confimBtnClick{
    NSLog(@"%@ %@ %@",_selectStr1,_selectStr2,_selectStr3);
    if (self.confirmAction) {
        self.confirmAction();
    }
}

#pragma mark  懒加载初始化
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat width = (SCREEN_WIDTH - 100) / 3;
        CGFloat height = 32;
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 56);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:(245 / 255.0) green:(245 / 255.0) blue:(245 / 255.0) alpha:1];
        [_collectionView addSubview:self.confirBtn];
        
        //注册cell
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
        [_collectionView registerClass:[MyCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    }
    return _collectionView;
}

- (UIButton *)confirBtn{
    if (!_confirBtn) {
        _confirBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirBtn.frame = CGRectMake(40, self.frame.size.height - 120, SCREEN_WIDTH - 80, 40);
        _confirBtn.backgroundColor = [UIColor colorWithRed:(126 / 255.0) green:(206 / 255.0) blue:(244 / 255.0) alpha:1];
        _confirBtn.layer.cornerRadius = 8;
        [_confirBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirBtn addTarget:self action:@selector(confimBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
