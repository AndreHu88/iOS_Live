//
//  HTTPManager.h
//  xtd
//
//  Created by leimo on 2017/8/10.
//  Copyright © 2017年 sj. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 网络请求成功的Block */
typedef void(^requestSuccess)(id returnData);
/** 网络请求失败的Block */
typedef void(^requestFailure)(NSError *error);


@interface HTTPManager : NSObject

/** 单例HTTPManager */
+ (instancetype )shareHTTPManager;

/*!
 @method
 @brief                 封装get请求
 @param url             get请求的URL
 @param para            get请求的参数
 @param isShowHUD       是否展示HUD
 @param successBlock    请求成功回调
 */
- (void)getDataFromUrl:(NSString *)url
         withParameter:(NSDictionary *)para
             isShowHUD:(BOOL)isShowHUD
               success:(requestSuccess)successBlock;

/*!
 @method
 @brief        封装POST请求
 @param url    请求的URL
 @param para   请求的参数
 @param isShowHUD       是否展示HUD
 @param successBlock    请求成功回调
 */
- (void)postDataFromUrl:(NSString *)url
         withParameter:(NSDictionary *)para
             isShowHUD:(BOOL)isShowHUD
                success:(requestSuccess)successBlock;



@end
