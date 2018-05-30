//
//  HYLyricTableViewCell.h
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLrcModel.h"

@interface HYLyricTableViewCell : UITableViewCell

@property (nonatomic,strong) HYLrcModel *lyricModel;
/** 当前播放的进度*/
@property (nonatomic, assign) CGFloat progress;

@end
