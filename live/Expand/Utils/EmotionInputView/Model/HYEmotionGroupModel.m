//
//  HYEmotionGroupModel.m
//  live
//
//  Created by Duntech on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYEmotionGroupModel.h"

@implementation HYEmotionModel

@end

@implementation HYEmotionGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"emotions" : [HYEmotionModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"emotions" : @"emoticons"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    [_emotions enumerateObjectsUsingBlock:^(HYEmotionModel *emotion, NSUInteger idx, BOOL *stop) {
        emotion.group = self;
    }];
    return YES;
}

@end
