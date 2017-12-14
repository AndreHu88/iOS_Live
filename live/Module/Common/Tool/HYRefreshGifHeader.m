//
//  HYRefreshGifHeader.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYRefreshGifHeader.h"

@implementation HYRefreshGifHeader


- (void)prepare{
    
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 29; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_00%02lu", (unsigned long)i]];
        image = [image imageByResizeToSize:CGSizeMake(45 * 118 / 97, 45) contentMode:UIViewContentModeScaleAspectFill];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 9; i < 21; i++) {
//
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_00%02lu", (unsigned long)i]];
//        [refreshingImages addObject:image];
//    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
    
}

@end
