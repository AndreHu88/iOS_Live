//
//  HYLyricTimeTool.m
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricTimeTool.h"

@implementation HYLyricTimeTool

+ (NSTimeInterval)getTimeInterval:(NSString *)formatTime{
    
    if (!formatTime) {
        return 0;
    }
    
    // 00:00.89  -> 多少秒
    NSArray *minAndSec = [formatTime componentsSeparatedByString:@":"];
    if (minAndSec.count == 2) {
        
        // 分钟
        NSTimeInterval min = [minAndSec[0] doubleValue];
        // 秒数
        NSTimeInterval sec = [minAndSec[1] doubleValue];
        
        return min * 60 + sec;
    }
    
    return 0;
}

+ (NSString *)getFormatTimeWithInterval:(NSTimeInterval)timeInterval{
    
    NSInteger time = (NSInteger)timeInterval;
    if (time / 3600 > 0) {
        // 时分秒
        NSInteger hour   = time / 3600;
        NSInteger minute = (time % 3600) / 60;
        NSInteger second = (time % 3600) % 60;
        
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, minute, second];
    }
    else {
        // 分秒
        NSInteger minute = time / 60;
        NSInteger second = time % 60;
        
        return [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
    }
}

@end
