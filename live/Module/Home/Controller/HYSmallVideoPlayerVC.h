//
//  HYSmallVideoPlayerVC.h
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYSmallVideoModel.h"

@interface HYSmallVideoPlayerVC : HYBaseViewController

@property (nonatomic,strong) HYSmallVideoModel *model;
/** 背景图片 */
@property (nonatomic,strong) UIImageView *bgImgView;
/** 截图 */
@property (nonatomic,strong) UIImage *snapImage;
/** 转场之前得图片为frame */
@property (nonatomic,assign) CGRect beforeImageViewFrame;

@end
