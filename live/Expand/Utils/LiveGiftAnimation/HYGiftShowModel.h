//
//  HYGiftShowModel.h
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYGiftModel.h"

@interface HYGiftShowModel : NSObject

@property (nonatomic,strong) HYGiftModel *giftModel;
@property (nonatomic,strong) HYGiftUserModel *giftUserModel;

+ (instancetype)giftShowModel:(HYGiftModel *)giftModel userModel:(HYGiftUserModel *)giftUserModel;

@end
