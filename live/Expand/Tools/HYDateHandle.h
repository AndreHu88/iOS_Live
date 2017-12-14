//
//  HYDateHandle.h
//  Agency
//
//  Created by Jack on 2017/11/21.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDateHandle : NSObject

/**
 *  将时间戳转换成昨天，前天，周一等
 */
+ (NSString *)distanceTimeWithBeforeTime:(long)beforeTimestamp;

@end
