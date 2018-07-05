//
//  HYSocketConfig.h
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#ifndef HYSocketConfig_h
#define HYSocketConfig_h

//网络环境，配置成可灵活切换
typedef NS_ENUM(NSUInteger, HYTCPServerEnvironment) {
    HYTCPServerEnvironmentTest,
    HYTCPServerEnvironmentDevelop,
    HYTCPServerEnvironmentRelease,
};

//这里模拟多个TCP的server
typedef NS_ENUM(NSUInteger, HYTCPServerType) {
    HYTCPServerTypeShangHai,
    HYTCPServerTypeGuangZhou,
    HYTCPServerTypeHK,
};

#ifdef DEBUG
#define DLog(format, ...) NSLog(@"%s():%d " format, __func__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif


#endif /* HYSocketConfig_h */
