//
//  HYLyricLabel.m
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricLabel.h"

@implementation HYLyricLabel

/** 重写 set 方法, 重新绘制*/
- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    if (_progress >= 0.99) {
        _progress = 0;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    // 1.设置填充色
    [KAPP_NETEASE_COLOR setFill];
    
    // 设置填充色的区域 (默认文字为白色,填充后为绿色,只需要根据当前歌词显示进度来改变填充的宽度,其他不变)
    CGRect fillRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * self.progress, rect.size.height);
    
    // 渲染
    // 在某个区域中使用混合模式进行填充
    /*
     kCGBlendModeNormal公式: R = S + D*(1 - Sa) --> 结果 = 源颜色 + 目标颜色 * (1-源颜色各透明组件的透明度)
     在这里;
     源颜色  -->  就是要绘制上去的颜色/填充色  ([[UIColor greenColor] setFill];)
     目标颜色 --> Label当前的颜色(白色和透明),上下文中已经有的颜色
     */
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
