//
//  HYLiveMessageModel.m
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveMessageModel.h"

@implementation HYLiveMessageModel


- (instancetype)initWithMessage:(RCMessage *)message {
    self = [super init];
    if (self) {
        
        self.targetId = message.targetId;
        self.messageId = message.messageId;
        self.senderUserId = message.senderUserId;
        self.content = message.content;
        self.extra = message.extra;
    }
    
    return self;
}

@end
