//
//  HYSocketUtils.m
//  live
//
//  Created by Duntech on 2018/6/4.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYSocketUtils.h"

@implementation HYSocketUtils

+ (NSData *)dataWithReverse:(NSData *)srcData{
    
    //    NSMutableData *dstData = [[NSMutableData alloc] init];
    //    for (NSUInteger i=0; i<srcData.length; i++) {
    //        [dstData appendData:[srcData subdataWithRange:NSMakeRange(srcData.length-1-i, 1)]];
    //    }//for
    
    NSUInteger byteCount = srcData.length;
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:srcData];
    NSUInteger halfLength = byteCount / 2;
    for (NSUInteger i = 0; i < halfLength; i++) {
        NSRange begin = NSMakeRange(i, 1);
        NSRange end = NSMakeRange(byteCount - i - 1, 1);
        NSData *beginData = [srcData subdataWithRange:begin];
        NSData *endData = [srcData subdataWithRange:end];
        [dstData replaceBytesInRange:begin withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:beginData.bytes];
    }//for
    
    return dstData;
}

+ (NSData *)byteFromUInt8:(uint8_t)val{
    
    NSMutableData *valData = [[NSMutableData alloc] init];
    unsigned char valChar[1];
    valChar[0] = 0xff & val;
    [valData appendBytes:valChar length:1];
    
    return [self dataWithReverse:valData];
}

+ (NSData *)bytesFromUInt16:(uint16_t)val{
    
    NSMutableData *valData = [[NSMutableData alloc] init];
    
    unsigned char valChar[2];
    valChar[0] = 0xff & val;
    valChar[1] = (0xff00 & val) >> 8;
    [valData appendBytes:valChar length:2];
    
    return [self dataWithReverse:valData];
}

+ (NSData *)bytesFromUInt32:(uint32_t)val{
    
    NSMutableData *valData = [[NSMutableData alloc] init];
    
    unsigned char valChar[4];
    valChar[0] = 0xff & val;
    valChar[1] = (0xff00 & val) >> 8;
    valChar[2] = (0xff0000 & val) >> 16;
    valChar[3] = (0xff000000 & val) >> 24;
    [valData appendBytes:valChar length:4];
    
    return [self dataWithReverse:valData];
}

+ (NSData *)bytesFromUInt64:(uint64_t)val{
    
    NSMutableData *valData = [[NSMutableData alloc] init];
    
    unsigned char valChar[8];
    valChar[0] = 0xff & val;
    valChar[1] = (0xff00 & val) >> 8;
    valChar[2] = (0xff0000 & val) >> 16;
    valChar[3] = (0xff000000 & val) >> 24;
    valChar[4] = (0xff00000000 & val) >> 32;
    valChar[5] = (0xff0000000000 & val) >> 40;
    valChar[6] = (0xff000000000000 & val) >> 48;
    valChar[7] = (0xff00000000000000 & val) >> 56;
    [valData appendBytes:valChar length:8];
    
    return [self dataWithReverse:valData];
}

+ (NSData *)bytesFromValue:(NSInteger)value byteCount:(int)byteCount{
    
    NSAssert(value <= 4294967295, @"bytesFromValue: (max value is 4294967295)");
    NSAssert(byteCount <= 4, @"bytesFromValue: (byte count is too long)");
    
    NSMutableData *valData = [[NSMutableData alloc] init];
    NSUInteger tempVal = value;
    int offset = 0;
    
    while (offset < byteCount) {
        unsigned char valChar = 0xff & tempVal;
        [valData appendBytes:&valChar length:1];
        tempVal = tempVal >> 8;
        offset++;
    }//while
    
    return valData;
}

+ (NSData *)bytesFromValue:(NSInteger)value byteCount:(int)byteCount reverse:(BOOL)reverse{
    
    NSData *tempData = [self bytesFromValue:value byteCount:byteCount];
    if (reverse) {
        return tempData;
    }
    
    return [self dataWithReverse:tempData];
}

+ (NSData *)convertDataFromObj:(id)obj{
    
    //利用runtime来做
    unsigned int ivarCount;
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]), &ivarCount);
    NSMutableData *data = [NSMutableData data];
    for (int i = 0; i < ivarCount; i++) {
        
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *propertyType = [[[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","] objectAtIndex:0];
        id propertyValue = [obj valueForKey:propertyName];
        
        if ([propertyType isEqualToString:TYPE_UINT8]) {
            uint8_t i = [propertyValue charValue];// 8位
            [data appendData:[self byteFromUInt8:i]];
        }
        else if([propertyType isEqualToString:TYPE_UINT16]){
            uint16_t i = [propertyValue shortValue];// 16位
            [data appendData:[self bytesFromUInt16:i]];
        }
        else if([propertyType isEqualToString:TYPE_UINT32]){
            uint32_t i = [propertyValue intValue];// 32位
            [data appendData:[self bytesFromUInt32:i]];
        }
        else if([propertyType isEqualToString:TYPE_UINT64]){
            uint64_t i = [propertyValue longLongValue];// 64位
            [data appendData:[self bytesFromUInt64:i]];
        }
        else if([propertyType isEqualToString:TYPE_STRING]){
            
            NSData *strData = [(NSString*)propertyValue dataUsingEncoding:NSUTF8StringEncoding];// 通过utf-8转为data
            
            // 用2个字节拼接字符串的长度拼接在字符串data之前
            [data appendData:[self bytesFromUInt16:strData.length]];
            // 然后拼接字符串
            [data appendData:strData];
            
        }else {
            NSLog(@"RequestSpliceAttribute:未知类型");
            NSAssert(YES, @"RequestSpliceAttribute:未知类型");
        }
    }
    
    free(propertys);    //释放C语言的结构体指针
    return data;
}

@end
