//
//  HYSmallVideoViewController.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYSmallVideoViewController.h"
#import "HYSmallVideoCollectionCell.h"
#import "HYSmallVideoModel.h"
#import "HYSmallVideoPlayerVC.h"

@interface HYSmallVideoViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *datalist;
/** 是否第一次加载 */
@property (nonatomic,assign) BOOL isFirstLoad;

@end

@implementation HYSmallVideoViewController

static NSString *cellID = @"smallVideoCellID";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.collectionView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - KTABBAR_HEIGHT - KNavTotal_HEIGHT);
    KAdjustsScrollViewInsets_NO(self, self.collectionView);
}

- (void)requestData{
    
    [HYNetWorkHandle getSmallVideoComplectionBlock:^(NSArray *datalist) {
       
        if (datalist) {
            
            [datalist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                HYSmallVideoModel *model = [HYSmallVideoModel modelWithDictionary:obj];
                NSDictionary *dict = [model.content jsonValueDecoded];
                model.contentInfo = [HYSmallVideoContent modelWithDictionary:dict];
                [self.datalist addObject:model];
            }];
            
            [_collectionView reloadData];
        }
    }];
}



#pragma mark - collectionDelegate datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYSmallVideoCollectionCell *cell = (HYSmallVideoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.datalist[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYSmallVideoCollectionCell *cell = (HYSmallVideoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    HYSmallVideoModel *model = self.datalist[indexPath.item];
    //设置转场动画 先清空之前的transition
    self.transition = nil;
    CGRect cellRect = [self.collectionView convertRect:cell.frame toView:self.collectionView];
    self.transition.beforeFrame = [self.collectionView convertRect:cellRect toView:self.view];
    self.transition.afterFrame = [UIScreen mainScreen].bounds;
    self.transition.transitionBeforeImgView = cell.coverImageView;
    self.navigationController.delegate = self.transition;
    
    HYSmallVideoPlayerVC *playerVC = [HYSmallVideoPlayerVC new];
    playerVC.beforeImageViewFrame = self.transition.beforeFrame;
    playerVC.model = model;
    UIImage *image = cell.coverImageView.image;
    playerVC.bgImgView.image = image;
    playerVC.snapImage = [self getScreenShot];
    [self.navigationController pushViewController:playerVC animated:YES];

}

//截图
- (UIImage *)getScreenShot{
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT);
    [KEYWINDOW drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    //从上下文中，取出image
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    //添加截取好的图片到数组
    if (snapshot) {
        
        return snapshot;
    }
    return nil;
}

#pragma mark - lazyload
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        CGFloat padding = 6 * WIDTH_MULTIPLE;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemWidth = (KSCREEN_WIDTH - padding * 2 - padding) / 2;
        CGFloat itemHeight = itemWidth * (KSCREEN_HEIGHT / (CGFloat)KSCREEN_WIDTH);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - KTABBAR_HEIGHT - KNavTotal_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = KAPP_TableView_BgColor;
        [_collectionView registerClass:[HYSmallVideoCollectionCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (NSMutableArray *)datalist{
    
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}

- (HYImageTransition *)transition{
    
    if (!_transition) {
        
        _transition = [HYImageTransition new];
    }
    return _transition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
