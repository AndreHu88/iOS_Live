//
//  HYDateHandle.m
//  Agency
//
//  Created by Jack on 2017/11/21.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYDateHandle.h"

@implementation HYDateHandle

+ (NSString *)distanceTimeWithBeforeTime:(long)beforeTimestamp{
    
    NSString *suffix = @"";
    NSString *result = @"";
    NSDate *referenceDate = [NSDate dateWithTimeIntervalSince1970:beforeTimestamp];
    NSInteger differTime = [[NSDate date] timeIntervalSinceDate:referenceDate];
    if (differTime < 0) {
        
        suffix = @"当前";
    }
    
    float dayDifferent = floor(differTime / (60 * 60 * 24));
    
    int days = (int)dayDifferent;
    int weeks = ceil(dayDifferent / 7);
    int months = ceil(dayDifferent / 30);
    int years = ceil(dayDifferent / 365);
    
    //今天内
    if (dayDifferent <= 0) {
        
        if (differTime < 30) {
            
            result = @"刚刚";
        }
        else if (differTime < 90){
            
            result = @"一分钟前";
        }
        else if (differTime < 30 * 60){
            
            result = @"半个小时前";
        }
        else if (differTime < 60 * 60){
            
            result = @"1个小时前";
        }
        else {
            
            result = [NSString stringWithFormat:@"%d个小时前",(int)floor(differTime / 3600)];
        }
        
    }
    else if (days <= 1){
        
        result = @"昨天";
    }
    else if (days <= 2){
        
        result = @"前天";
    }
    else if (days < 7){
        
        result = [NSString stringWithFormat:@"%d天前",days];
    }
    else if (weeks < 4){
        
        result = [NSString stringWithFormat:@"%d周前",weeks];
    }
    else if (months < 12){
        
        result = [NSString stringWithFormat:@"%d月前",months];
    }
    else{
        
        result = [NSString stringWithFormat:@"%d前",years];
    }
    
    
    return result;
}

@end
