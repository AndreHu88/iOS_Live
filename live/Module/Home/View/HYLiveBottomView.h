//
//  HYLiveBottomView.h
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLiveViewModel.h"
#import "HYSmallVideoViewModel.h"

@interface HYLiveBottomView : UIView

- (void)setWithViewModel:(HYLiveViewModel *)viewModel;

- (void)setWithSmallVideoViewModel:(HYSmallVideoViewModel *)smallVideoViewModel;

@end
