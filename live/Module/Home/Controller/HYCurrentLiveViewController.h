//
//  HYCurrentLiveViewController.h
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYHotLiveModel.h"

@interface HYCurrentLiveViewController : HYBaseViewController

@property (nonatomic,strong) HYHotLiveModel *liveModel;
/** 当前的index */
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray *modelList;

@end
