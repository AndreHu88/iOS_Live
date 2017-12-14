//
//  HYNetWorkHandle.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYNetWorkHandle.h"

@implementation HYNetWorkHandle

+ (void)getHotLiveListComplectionBlock:(void (^)(NSArray *))complection{
    
    [[HTTPManager shareHTTPManager] getDataFromUrl:API_HotLive withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            NSInteger code = [[returnData objectForKey:@"dm_error"] integerValue];
            if (code == 0) {
                
                NSArray *array = returnData[@"lives"];
                if (array.count) {
                    
                    complection(array);
                }
                else{
                    
                    complection(array);
                }
            }
            else{
                
                complection(nil);
                [JRToast showWithText:[returnData valueForKey:@"error_msg"]];
            }
        }
        else{
            
            complection(nil);
            [JRToast showWithText:@"获取热门直播失败" duration:2];
        }
    }];
}

+ (void)getSmallVideoComplectionBlock:(void (^)(NSArray *))complection{
    
    [[HTTPManager shareHTTPManager] getDataFromUrl:API_SmallVideo withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            NSInteger code = [[returnData objectForKey:@"dm_error"] integerValue];
            if (code == 0) {
                
                NSArray *array = returnData[@"feeds"];
                if (array.count) {
                    
                    complection(array);
                }
                else{
                    
                    complection(array);
                }
            }
            else{
                
                complection(nil);
                [JRToast showWithText:[returnData valueForKey:@"error_msg"]];
            }
        }
        else{
            
            complection(nil);
            [JRToast showWithText:@"获取小视频失败" duration:2];
        }
    }];
}

+ (void)getEatChickenComplectionBlock:(void (^)(NSArray *))complection{
    
    [[HTTPManager shareHTTPManager] getDataFromUrl:API_EatChicken withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            NSInteger code = [[returnData objectForKey:@"dm_error"] integerValue];
            if (code == 0) {
                
                NSArray *array = returnData[@"lives"];
                if (array.count) {
                    
                    complection(array);
                }
                else{
                    
                    complection(array);
                }
            }
            else{
                
                complection(nil);
                [JRToast showWithText:[returnData valueForKey:@"error_msg"]];
            }
        }
        else{
            
            complection(nil);
            [JRToast showWithText:@"获取吃鸡失败" duration:2];
        }
    }];
}

+ (void)getNearDataWithLatitude:(NSString *)latitude longitude:(NSString *)longitude ComplectionBlock:(void (^)(NSArray *))complection{
    
    NSString *near_host = API_NearLive(latitude, longitude);
    [[HTTPManager shareHTTPManager] getDataFromUrl:near_host withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            NSInteger code = [[returnData objectForKey:@"dm_error"] integerValue];
            if (code == 0) {
                
                NSArray *array = returnData[@"lives"];
                if (array.count) {
                    
                    complection(array);
                }
                else{
                    
                    complection(array);
                }
            }
            else{
                
                complection(nil);
                [JRToast showWithText:[returnData valueForKey:@"error_msg"]];
            }
        }
        else{
            
            complection(nil);
            [JRToast showWithText:@"获取附近直播失败" duration:2];
        }
    }];
}

@end
