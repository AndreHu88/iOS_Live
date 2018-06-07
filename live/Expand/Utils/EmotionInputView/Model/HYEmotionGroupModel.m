//
//  HYEmotionGroupModel.m
//  live
//
//  Created by Duntech on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYEmotionGroupModel.h"

@implementation HYemotionModel

@end

@implementation HYEmotionGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"emotions" : [HYemotionModel class]};
}

@end
