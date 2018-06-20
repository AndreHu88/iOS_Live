//
//  HTTPManager.m
//  xtd
//
//  Created by leimo on 2017/8/10.
//  Copyright © 2017年 sj. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

+ (instancetype)shareHTTPManager{

    static HTTPManager *httpManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        httpManager = [HTTPManager new];
    });
    return httpManager;
}

- (void)getDataFromUrl:(NSString *)url withParameter:(NSDictionary *)para isShowHUD:(BOOL)isShowHUD success:(requestSuccess)successBlock{
    
    if (isShowHUD) {

        dispatch_async(dispatch_get_main_queue(), ^{

            [HYLoadingManager showInkeLoading];
        });
    }
    
//    NSString *urlString= [NSString stringWithFormat:@"%@/%@",API_DomainStr,url];
    NSString *urlString = url;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"text/html", nil];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.securityPolicy.allowInvalidCertificates = YES;

    
    [manager GET:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HYLoadingManager dismissLoadingView];
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        successBlock(nil);
        [HYLoadingManager dismissLoadingView];
        [JRToast showWithText:@"服务器开小差了"];

    }];
}

- (void)postDataFromUrl:(NSString *)url withParameter:(NSDictionary *)para isShowHUD:(BOOL)isShowHUD success:(requestSuccess)successBlock{

    if (isShowHUD) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HYLoadingManager showInkeLoading];
        });
        
    }
    
//    NSString *urlString= [NSString stringWithFormat:@"%@/%@",API_DomainStr,url];
    NSString *urlString = url;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;

    //采用JSON的方式来解析数据
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HYLoadingManager dismissLoadingView];

        });
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HYLoadingManager dismissLoadingView];
        successBlock(nil);
        [JRToast showWithText:@"服务器开小差了"];
    }];
}


@end
