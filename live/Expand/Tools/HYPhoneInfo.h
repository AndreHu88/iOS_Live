//
//  HYPhoneInfo.h
//  FlowerHan
//
//  Created by huyong on 2017/7/4.
//  Copyright © 2017年 leimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPhoneInfo : NSObject

/*!
 @method
 @brief     获取IOS版本
 @return    ios版本
 */
+ (NSString *)phoneVersion;

/*!
 @method
 @brief     获取手机型号
 @return    手机型号
 */
+ (NSString *)phoneModel;

/**
 *  获取手机电量
 */
+ (CGFloat)batterylevel;

/**
 *  获取网络类型
 */
+ (NSString *)networkType;

/**
 *  获取APP名称
 */
+ (NSString *)appName;

/**
 *  获取APP版本
 */
+ (NSString *)appVersion;

/**
 *  获取IP地址
 */
+ (NSString *)getIPAddress;

@end
