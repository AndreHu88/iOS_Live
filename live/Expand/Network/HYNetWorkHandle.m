//
//  HYNetWorkHandle.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYNetWorkHandle.h"
#import "HYNearLiveModel.h"

@implementation HYNetWorkHandle

+ (void)getHotLiveListComplectionBlock:(void (^)(NSArray *))complection{
    
    [[HTTPManager shareHTTPManager] getDataFromUrl:API_HotLive withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            NSInteger code = [[returnData objectForKey:@"dm_error"] integerValue];
            if (code == 0) {
                
                NSArray *array = returnData[@"data"];
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
                    
                    //多线程中去处理数据
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSMutableArray *tempArray = [NSMutableArray array];
                        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            HYNearLiveModel *model = [HYNearLiveModel modelWithDictionary:obj];
                            [tempArray addObject:model];
                        }];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            complection(tempArray);
                        });
                    });
                }
                else{
                    
                    complection(nil);
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

+ (void)getXiaMiMusicList:(void (^)(NSArray *))complection{
    
    [[HTTPManager shareHTTPManager] getDataFromUrl:API_XiaMiMusicList withParameter:nil isShowHUD:YES success:^(id returnData) {
        
        if (returnData) {
            
            if ([returnData objectForKey:@"status"]) {
                
                NSArray *array = returnData[@"resultObj"][@"songs"];
                if (array.count) {
                    
                    complection(array);
                }
                else{
                    
                    complection(array);
                }
            }
            else{
                
                complection(nil);
                [JRToast showWithText:[returnData valueForKey:@"msg"]];
            }
        }
        else{
            
            complection(nil);
        }
    }];
}

@end
