//
//  HYGiftCountLabel.m
//  live
//
//  Created by Duntech on 2018/6/22.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYGiftCountLabel.h"

@implementation HYGiftCountLabel

- (void)startAnimationWithDuration:(NSInteger)duration{
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        //startTime：关键帧开始时间，该时间是相对整个关键帧动画持续时间的相对时间，一般值在0到1之间。如果为0，则表明这一关键帧从整个动画的第0秒开始执行，如果设为0.5，则表明从整个动画的中间开始执行。
        //relativeDuration：关键帧持续时间，该时间同样是相对整个关键帧动画持续时间的相对时间，一般值也在0到1之间。如果设为0.25，则表明这一关键帧的持续时间为整个动画持续时间的四分之一
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            
            self.transform = CGAffineTransformMakeScale(4, 4);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)drawTextInRect:(CGRect)rect{
    
    [super drawTextInRect:rect];
    CGContextRef contentRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contentRef, 4);
    CGContextSetLineJoin(contentRef, kCGLineJoinRound);
    CGContextSetTextDrawingMode(contentRef, kCGTextStroke);
    [self.borderColor setStroke];
    
    CGContextSetTextDrawingMode(contentRef, kCGTextFill);

}

@end
