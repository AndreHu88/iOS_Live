//
//  DESECB.h
//  LieLie
//
//  Created by huyong on 16/7/9.
//  Copyright © 2016年 胡勇 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESECB : NSObject
/**
 *  DES 原始方法
 *  DES加密算法： ECB模式
 */
//加密
+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key;
//解密
+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
