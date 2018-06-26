//
//  HYPieView.h
//  Live
//
//  Created by JackHu on 2018/6/25.
//  Copyright © 2018年 JackHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPieView : UIView

- (instancetype)initWithFrame:(CGRect)frame datasArray:(NSArray<NSNumber *> *)dataNumbers colors:(NSArray<UIColor *> *)colors;

- (void)strokeAnimation;

@end

