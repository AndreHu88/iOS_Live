//
//  SSKeychain+HYCommon.m
//  live
//
//  Created by Duntech on 2018/7/27.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "SSKeychain+HYCommon.h"

@implementation SSKeychain (HYCommon)

+ (NSString *)password {
    return [self passwordForService:Service_Name account:User_Password];
}

+ (NSString *)accessToken {
    return [self passwordForService:Service_Name account:User_AccessToken];
}

+ (BOOL)setPassword:(NSString *)password {
    return [self setPassword:password forService:Service_Name account:User_Password];
}

+ (BOOL)setAccessToken:(NSString *)accessToken {
    return [self setPassword:accessToken forService:Service_Name account:User_AccessToken];
}

+ (BOOL)deletePassword {
    return [self deletePasswordForService:Service_Name account:User_Password];
}

+ (BOOL)deleteAccessToken {
    return [self deletePasswordForService:Service_Name account:User_AccessToken];
}

@end
