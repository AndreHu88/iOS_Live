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

@end
