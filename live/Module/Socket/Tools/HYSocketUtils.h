//
//  HYSocketUtils.h
//  live
//
//  Created by Duntech on 2018/6/4.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSocketUtils : NSObject

/** 反转data */
+ (NSData *)dataWithReverse:(NSData *)srcData;

/** 将数值转成字节。编码方式：低位在前，高位在后 */
+ (NSData *)byteFromUInt8:(uint8_t)val;
+ (NSData *)bytesFromUInt16:(uint16_t)val;
+ (NSData *)bytesFromUInt32:(uint32_t)val;
+ (NSData *)bytesFromUInt64:(uint64_t)val;
+ (NSData *)bytesFromValue:(NSInteger)value byteCount:(int)byteCount;
+ (NSData *)bytesFromValue:(NSInteger)value byteCount:(int)byteCount reverse:(BOOL)reverse;

/** 将OC的模型转换成要发送的data */
+ (NSData *)convertDataFromObj:(id)obj;

@end
