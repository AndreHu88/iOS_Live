//
//  HTTPManager.m
//  xtd
//
//  Created by leimo on 2017/8/10.
//  Copyright © 2017年 sj. All rights reserved.
//

#import "HTTPManager.h"

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
};

@implementation HTTPManager

static AFHTTPSessionManager *manager;
static HTTPManager *httpManager;

+ (instancetype)shareHTTPManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        httpManager = [HTTPManager new];
    });
    return httpManager;
}

- (void)getDataFromUrl:(NSString *)url withParameter:(NSDictionary *)para isShowHUD:(BOOL)isShowHUD success:(requestSuccess)successBlock{
    
    [self requestUrl:url requestType:RequestTypeGet parameter:para isShowHUD:isShowHUD success:successBlock failure:nil];
}

- (void)postDataFromUrl:(NSString *)url withParameter:(NSDictionary *)para isShowHUD:(BOOL)isShowHUD success:(requestSuccess)successBlock{

    
    [self requestUrl:url requestType:RequestTypePost parameter:para isShowHUD:isShowHUD success:successBlock failure:nil];
}

- (void)requestUrl:(NSString *)url requestType:(RequestType)type parameter:(NSDictionary *)para isShowHUD:(BOOL)isShowHUD success:(requestSuccess)successBlock failure:(requestFailure)failure{
    
    if (manager.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable ) {
        
        [JRToast showWithText:@"The network is lost,please check your network" duration:2];
//        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10010 userInfo:@{@"key" : @"network not connect"}];
        successBlock(nil);
        return;
    }
    
    if (isShowHUD) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HYLoadingManager showInkeLoading];
        });
    }
    
    
    //    NSString *urlString= [NSString stringWithFormat:@"%@/%@",API_DomainStr,url];
    NSString *urlString = url;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0f;
    DLog(@"url: %@ \nparam: %@", urlString, para);
    if (type == RequestTypeGet) {
        
        [manager GET:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [HYLoadingManager dismissLoadingView];
            successBlock(responseObject);
            DLog(@"%@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            successBlock(nil);
            [HYLoadingManager dismissLoadingView];
            [JRToast showWithText:@"少年，服务器游走去了"];
            DLog(@"%@", error);
        }];
    }
    else{
        
        [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HYLoadingManager dismissLoadingView];
                
            });
            successBlock(responseObject);
            DLog(@"%@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [HYLoadingManager dismissLoadingView];
            successBlock(nil);
            [JRToast showWithText:@"少年，服务器游走去了"];
            DLog(@"%@", error);

        }];
    }
    
}

@end
