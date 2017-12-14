
//
//  HYSmallVideoViewModel.m
//  live
//
//  Created by Jack on 2017/12/8.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYSmallVideoViewModel.h"

@implementation HYSmallVideoViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initilize];
    }
    return self;
}
- (void)initilize{
    
    _quitPlayerSubject = [RACSubject subject];
}

@end
