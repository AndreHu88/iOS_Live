//
//  HYSmallVideoCollectionCell.h
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSmallVideoModel.h"

@interface HYSmallVideoCollectionCell : UICollectionViewCell

/** 封面图 */
@property (nonatomic,strong) UIImageView *coverImageView;
/** 小视频model */
@property (nonatomic,strong) HYSmallVideoModel *model;

@end
