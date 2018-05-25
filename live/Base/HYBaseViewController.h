//
//  HYBaseViewController.h
//  Agency
//
//  Created by 胡勇 on 2017/11/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBaseViewController : UIViewController

- (void)setStatusBarBackgroundColor:(UIColor *)color;

- (void)setupNav;

- (void)backBtnAction;

+ (UIViewController *)getCurrentVC;

@end
