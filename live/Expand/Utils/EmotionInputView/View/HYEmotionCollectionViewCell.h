//
//  HYEmotionCollectionViewCell.h
//  live
//
//  Created by Duntech on 2018/6/14.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYEmotionGroupModel.h"

@interface HYEmotionCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) HYEmotionModel *emotionModel;
@property (nonatomic,assign) BOOL isDelete;

@end
