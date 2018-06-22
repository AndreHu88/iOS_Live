//
//  HYAnimationOperation.m
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYAnimationOperation.h"

@interface HYAnimationOperation ()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;

@property (nonatomic,strong) HYGiftShowModel *giftModel;
@property (nonatomic,copy) void(^finishedBlock)(BOOL isFinish, NSInteger finishCount);

@end


@implementation HYAnimationOperation

//手动合成属性
@synthesize finished = _finished;
@synthesize executing = _executing;


+ (instancetype)animationOperationWithUserID:(NSString *)userID giftShowModel:(HYGiftShowModel *)giftModel superView:(UIView *)parentView finishBlock:(void (^)(BOOL, NSInteger))finishedBlock{
    
    HYAnimationOperation *operation = [HYAnimationOperation new];
    operation.animationView = [HYGiftAnimationView new];
    operation.giftModel = giftModel;
    operation.finishedBlock = finishedBlock;
    operation.parentView = parentView;
    return operation;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
       
        self.finished = NO;
        self.executing = NO;
    }
    return self;
}

#pragma mark - override
- (void)start{
    
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
       
        self.animationView.giftModel = _giftModel;
        self.animationView.originFrame = _animationView.frame;
        [self.parentView addSubview:_animationView];
        [self.animationView animationComplectionBlock:^(BOOL isFinished, NSInteger count) {
           
            self.finished = isFinished;
            self.finishedBlock(isFinished, count);
        }];
    }];
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing{
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished{
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
