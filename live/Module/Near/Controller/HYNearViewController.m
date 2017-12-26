//
//  HYNearViewController.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYNearViewController.h"
#import "HYLocationManager.h"
#import "HYNearLiveModel.h"
#import "HYNearCollectionViewCell.h"
#import "HYCurrentLiveViewController.h"

@interface HYNearViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

/** collectionView  */
@property (nonatomic,strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *datalist;

@end

static NSString *cellIdentifer = @"HYNearCollectionViewCell";

@implementation HYNearViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    KAdjustsScrollViewInsets_NO(self, self.collectionView);
    [self.view addSubview:self.collectionView];
    [self requestData];
    self.navigationItem.title = @"附近的直播";
}

- (void)viewDidLayoutSubviews{
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

- (void)requestData{
    
    NSString *latitude = [HYLocationManager sharedManager].lat;
    NSString *longitude = [HYLocationManager sharedManager].lon;
    [HYNetWorkHandle getNearDataWithLatitude:latitude longitude:longitude ComplectionBlock:^(NSArray *datalist) {
        
        [self.datalist addObjectsFromArray:datalist];
        [self.collectionView reloadData];
    }];
}

#pragma mark - collectionDelegate dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.datalist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYNearCollectionViewCell *cell = (HYNearCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.model = self.datalist[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYNearCollectionViewCell *currentCell = (HYNearCollectionViewCell *)cell;
    [currentCell showAnimation];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYNearLiveModel *model = self.datalist[indexPath.item];
    HYCurrentLiveViewController *liveVC = [HYCurrentLiveViewController new];
    liveVC.liveModel = (HYHotLiveModel *)model;
    liveVC.currentIndex = indexPath.row;
    liveVC.modelList = self.datalist;
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma mark - lazyload
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        CGFloat padding = 6 * WIDTH_MULTIPLE;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = (KSCREEN_WIDTH - padding * 3 - padding) / 3;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 40 * WIDTH_MULTIPLE);
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = KAPP_WHITE_COLOR;
        [_collectionView registerClass:[HYNearCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifer];
    }
    return _collectionView;
}

- (NSMutableArray *)datalist{
    
    if (!_datalist) {
        _datalist = [NSMutableArray array];
    }
    return _datalist;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
