//
//  HYEmotionInputHelper.h
//  live
//
//  Created by Duntech on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYEmotionGroupModel.h"

@interface HYEmotionInputHelper : NSObject

+ (NSBundle *)resourceBundle;

+ (UIImage *)emotionImageNamed:(NSString *)imageName;

@end
