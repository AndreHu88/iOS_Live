//
//  HYMineHeaderView.h
//  live
//
//  Created by 胡勇 on 2018/7/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SettingBtnActionBlock)(void);
typedef void(^MessageBtnActionBlock)(void);
typedef void(^HeaderImgTapBlock)(NSString *url);

@interface HYMineHeaderView : UIView

@property (nonatomic,copy) SettingBtnActionBlock settingActionBlock;
@property (nonatomic,copy) MessageBtnActionBlock messageActionBlock;
@property (nonatomic,copy) HeaderImgTapBlock headerImgActionBlcok;

@end
