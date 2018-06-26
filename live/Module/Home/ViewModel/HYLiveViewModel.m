//
//  HYLiveViewModel.m
//  live
//
//  Created by Jack on 2017/11/28.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveViewModel.h"

@interface HYLiveViewModel()

@end

@implementation HYLiveViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initilize];
    }
    return self;
}

- (void)setWithViewModel:(HYHotLiveModel *)model{
    
    self.stream_url = model.stream_addr;
    self.targetID = @"ChatRoom01";
}

- (void)initilize{
    
    _isScrollViewCanScroll = YES;
    _chatSubject = [RACSubject subject];
    _closeLiveSubject = [RACSubject subject];
    _giftSubject = [RACSubject subject];
}

@end
