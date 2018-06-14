//
//  HYHomeLaunchView.h
//  live
//
//  Created by Jack on 2017/12/26.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYHomeLaunchView : UIView

@property (nonatomic, copy)   void(^buttonClickBlock)(NSInteger index);
- (void)showLaunchView;

@end
