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
            
            HYAnimationOperation *operation = [self.operationCache objectForKey:userID];
            operation.animationView.giftCount = showModel.giftModel.count;
            [operation.animationView shakeGiftCountLabel];
            return;
        }
        
        //创建操作
        HYAnimationOperation *operation = [HYAnimationOperation animationOperationWithUserID:userID giftShowModel:showModel superView:self.containerView finishBlock:^(BOOL isFinish, NSInteger finishCount) {
           
            if (finishBlcok) {
                finishBlcok(isFinish);
            }
            //将礼物数量保存
            [self.userGiftInfoCache setObject:@(finishCount) forKey:userID];
            //移除对应的操作操作
            [self.operationCache removeObjectForKey:userID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfoCache removeObjectForKey:userID];
            });
        }];
        
        //获取当前的礼物数量
        operation.animationView.giftCount = [[self.userGiftInfoCache objectForKey:userID] integerValue];
        operation.parentView = self.containerView;
        //将操作添加到操作缓存池
        [self.operationCache setObject:operation forKey:userID];
        if (showModel.giftModel.count > 0) {
            
            operation.parentView.frame  = CGRectMake(- self.containerView.frame.size.width / 2, 300, self.containerView.frame.size.width / 2, 40);
            [self.operationQueue addOperation:operation];
        }
        
    }
    else{
        
        //当前用户没有送过礼物
        //如果有操作缓存,直接累加数值
        if ([self.operationCache objectForKey:userID]) {
            
            HYAnimationOperation *operation = [self.operationCache objectForKey:userID];
            operation.animationView.giftCount += showModel.giftModel.count;
            [operation.animationView shakeGiftCountLabel];
            return;
        }
        //创建操作
        HYAnimationOperation *operation = [HYAnimationOperation animationOperationWithUserID:userID giftShowModel:showModel superView:self.containerView finishBlock:^(BOOL isFinish, NSInteger finishCount) {
            
            if (finishBlcok) {
                finishBlcok(isFinish);
            }
            //将礼物数量保存
            [self.userGiftInfoCache setObject:@(finishCount) forKey:userID];
            //移除对应的操作操作
            [self.operationCache removeObjectForKey:userID];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.userGiftInfoCache removeObjectForKey:userID];
            });
        }];
        operation.parentView = self.containerView;
        //将操作添加到操作缓存池
        [self.operationCache setObject:operation forKey:userID];
        if (showModel.giftModel.count > 0) {
            
            operation.parentView.frame  = CGRectMake(- self.containerView.frame.size.width / 2, 300, self.containerView.frame.size.width / 2, 40);
            [self.operationQueue addOperation:operation];
        }
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

- (NSOperationQueue *)operationQueue{
    
    if (!_operationQueue) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
        //设置queue为串行
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
