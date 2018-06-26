//
//  HYGiftView.m
//  live
//
//  Created by 胡勇 on 2018/6/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYGiftView.h"

@interface HYGiftView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *giftCollectionView;

@end

@implementation HYGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat itemWidth = KSCREEN_WIDTH / 4;
    CGFloat itemHeight = self.height / 2;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _giftCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _giftCollectionView.delegate = self;
    _giftCollectionView.dataSource = self;
    _giftCollectionView.pagingEnabled = YES;
    _giftCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.giftCollectionView registerClass:[HYGiftCell class] forCellWithReuseIdentifier:@"HYGiftCell"];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYGiftCell" forIndexPath:indexPath];
    
    return cell;
}


@end


@implementation HYGiftCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

@end
