//
//  HYLiveCollectionViewCell.h
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHotLiveModel.h"
#import "HYLiveViewModel.h"

@interface HYLiveCollectionViewCell : UICollectionViewCell

/** 当前的model */
@property (nonatomic,strong) HYHotLiveModel *currentLiveModel;

- (void)setWithViewModel:(HYLiveViewModel *)viewModel;

@end
