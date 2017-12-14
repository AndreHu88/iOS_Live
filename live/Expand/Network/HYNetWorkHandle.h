//
//  HYNetWorkHandle.h
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYNetWorkHandle : NSObject

/**
 *  获取热门直播数据
 */
+ (void)getHotLiveListComplectionBlock:(void(^)(NSArray *datalist))complection;

/**
 *  获取热门小视频数据
 */
+ (void)getSmallVideoComplectionBlock:(void(^)(NSArray *datalist))complection;

/**
 *  获取吃鸡数据
 */
+ (void)getEatChickenComplectionBlock:(void(^)(NSArray *datalist))complection;

/**
 *  获取附近的数据
 */
+ (void)getNearDataWithLatitude:(NSString *)latitude longitude:(NSString *)longitude ComplectionBlock:(void(^)(NSArray *datalist))complection;

@end
