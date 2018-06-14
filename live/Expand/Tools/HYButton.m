//
//  HYButton.m
//  xtd
//
//  Created by leimo on 2017/8/25.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "HYButton.h"

/** 图片和文字的比例 */
static CGFloat imageScale = 0.5;

@implementation HYButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

#pragma mark - public
- (void)shakeAnimationWithDelay:(CGFloat)delay{
    
    CGRect originFrmae = self.frame;
    self.frame = CGRectMake(originFrmae.origin.x, originFrmae.origin.y - 100, self.width, self.height);
    [UIView animateWithDuration:4 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.frame = originFrmae;
        self.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    
}

//重写button的
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * imageScale;
    
    return CGRectMake(0, 0, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * imageScale;
    CGFloat y = contentRect.size.height - height;
    
    return CGRectMake(0, y + 7, width, height - 7);
}

@end
