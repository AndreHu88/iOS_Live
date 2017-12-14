//
//  HYNearViewController.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYNearViewController.h"
#import "HYLocationManager.h"

@interface HYNearViewController ()

/** collectionView  */
@property (nonatomic,strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *datalist;

@end

@implementation HYNearViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self requestData];
    
}

- (void)requestData{
    
    NSString *latitude = [HYLocationManager sharedManager].lat;
    NSString *longitude = [HYLocationManager sharedManager].lon;
    [HYNetWorkHandle getNearDataWithLatitude:latitude longitude:longitude ComplectionBlock:^(NSArray *datalist) {
       
        if (datalist) {
            
        }
    }];
}


#pragma mark - lazyload
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        CGFloat padding = 6 * WIDTH_MULTIPLE;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((KSCREEN_WIDTH - padding * 2) / 2 - padding / 2, 300 * WIDTH_MULTIPLE);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 64 - 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = KAPP_TableView_BgColor;
        
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
