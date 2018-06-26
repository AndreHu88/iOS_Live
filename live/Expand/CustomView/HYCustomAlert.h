//
//  HYCustomAlert.h
//  DaCongMing
//
//  Created by 胡勇 on 2017/9/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmActionBlcok)(void);

@interface HYCustomAlert : UIView

/** 确定 */
@property (nonatomic,copy) confirmActionBlcok actionBlock;

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title content:(NSString *)content confirmBlock:(void(^)(void))confirmAction;

- (void)showCustomAlert;

@end
