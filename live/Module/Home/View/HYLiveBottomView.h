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

@protocol HYLiveBottomViewActionDelegate <NSObject>

- (void)buttonClikckWithIndex:(NSInteger)index;

@end

@interface HYLiveBottomView : UIView

@property (nonatomic,weak) id<HYLiveBottomViewActionDelegate> delegate;

- (void)setWithViewModel:(HYLiveViewModel *)viewModel;

- (void)setWithSmallVideoViewModel:(HYSmallVideoViewModel *)smallVideoViewModel;

@end
