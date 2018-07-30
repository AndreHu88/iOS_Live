//
//  SSKeychain+HYCommon.h
//  live
//
//  Created by Duntech on 2018/7/27.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "SSKeychain.h"

@interface SSKeychain (HYCommon)

+ (NSString *)password;
+ (NSString *)accessToken;

+ (BOOL)setPassword:(NSString *)password;
+ (BOOL)setAccessToken:(NSString *)accessToken;

+ (BOOL)deletePassword;
+ (BOOL)deleteAccessToken;

@end
