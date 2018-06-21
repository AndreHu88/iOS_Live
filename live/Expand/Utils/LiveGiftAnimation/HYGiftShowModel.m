//
//  HYGiftShowModel.m
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYGiftShowModel.h"

@implementation HYGiftShowModel

+ (instancetype)giftShowModel:(HYGiftModel *)giftModel userModel:(HYGiftUserModel *)giftUserModel{
    
    HYGiftShowModel *giftShowModel = [HYGiftShowModel new];
    giftShowModel.giftModel = giftModel;
    giftShowModel.giftUserModel = giftUserModel;
    return giftShowModel;
}

@end
