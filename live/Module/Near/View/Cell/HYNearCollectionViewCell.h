//
//  HYNearCollectionViewCell.h
//  live
//
//  Created by Jack on 2017/12/26.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNearLiveModel.h"

@interface HYNearCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) HYNearLiveModel *model;

- (void)showAnimation;

@end
