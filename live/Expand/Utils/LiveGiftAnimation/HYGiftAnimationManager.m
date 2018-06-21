//
//  HYGiftAnimationManager.m
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYGiftAnimationManager.h"

@interface HYGiftAnimationManager ()

/** 操作缓存 */
@property (nonatomic,strong) NSCache *operationCache;
/** 用户礼物缓存 */
@property (nonatomic,strong) NSCache *userGiftInfoCache;
/** 队列 */
@property (nonatomic,strong) NSOperationQueue *operationQueue;

@end

@implementation HYGiftAnimationManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    static HYGiftAnimationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [HYGiftAnimationManager new];
    });
    return manager;
}

#pragma mark - PublicMethod
- (void)giftAnimationWithUserID:(NSString *)userID giftShowModel:(HYGiftShowModel *)showModel animationFinishBlock:(void (^)(BOOL))finishBlcok{
    
    //当前用户已经送过礼物
    if ([self.userGiftInfoCache objectForKey:userID]) {
        
        //如果有操作缓存,直接累加数值
        if ([self.operationCache objectForKey:userID]) {
            
            
        }
        
        //创建操作
        
        
    }
    else{
        
        
    }
}

- (void)cancelGiftAnimationWithUserID:(NSString *)userID{
    
    
}

#pragma mark - lazyload
- (NSCache *)operationCache{
    
    if (!_operationCache) {
        _operationCache = [NSCache new];
    }
    return _operationCache;
}

- (NSCache *)userGiftInfoCache{
    
    if (!_userGiftInfoCache) {
        _userGiftInfoCache = [NSCache new];
    }
    return _userGiftInfoCache;
}

@end
