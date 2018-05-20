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
    
    CGAffineTransform topTransform = CGAffineTransformMakeTranslation(0, 400);
    CGAffineTransform topTransform2 = CGAffineTransformMakeTranslation(0, -200);
    CGAffineTransform bottomTransform = CGAffineTransformMakeTranslation(0, 5);
    
    [UIView animateWithDuration:4 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.transform = topTransform;
    } completion:^(BOOL finished) {

        self.transform = CGAffineTransformIdentity;
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
