//
//  FilterVIew.h
//  PopView
//
//  Created by LEMO on 2017/2/20.
//  Copyright © 2017年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmBtnAction)();

@interface FilterVIew : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) confirmBtnAction confirmAction;

@end
