//
//  HYLiveScrollView.h
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHotLiveModel.h"
#import "HYLiveViewModel.h"

@interface HYLiveScrollView : UIScrollView

/** 当前的model */
@property (nonatomic,strong) HYHotLiveModel *currentLiveModel;
/** 当前的index */
@property (nonatomic,assign) NSInteger currentIndex;
/** 所有的model */
@property (nonatomic,strong) NSArray *modelList;
/** viewModel */
@property (nonatomic,strong) HYLiveViewModel *viewModel;

@end
