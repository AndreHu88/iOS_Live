//
//  HYReachabilityManager.m
//  Agency
//
//  Created by 胡勇 on 2017/11/14.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYReachabilityManager.h"

@implementation HYReachabilityManager

+ (void)listenNetWorkingStatus{
    
    //1:创建网络监听者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开启网络监听
    [manager startMonitoring];
    
    //2:获取网络状态
    /*
     AFNetworkReachabilityStatusUnknown          = 未知网络，
     AFNetworkReachabilityStatusNotReachable     = 没有联网
     AFNetworkReachabilityStatusReachableViaWWAN = 蜂窝数据
     AFNetworkReachabilityStatusReachableViaWiFi = 无线网
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                DLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"--------没有网络-------");
                [JRToast showWithText:@"无网络连接"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"--------移动数据-------");
                [JRToast showWithText:@"网络状态发生变化，切换到移动数据"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"--------WiFi环境-------");
                break;
            default:
                break;
        }
    }];
    
    
    
}

@end
