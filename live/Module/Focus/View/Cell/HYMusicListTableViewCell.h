//
//  HYMusicListTableViewCell.h
//  live
//
//  Created by 胡勇 on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYBaseTableViewCell.h"

@interface HYMusicListTableViewCell : HYBaseTableViewCell

@property (nonatomic,strong) HYXiaMiMusicModel *musicModel;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@end
