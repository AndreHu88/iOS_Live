//
//  HYLyricHandleTool.h
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYLrcModel.h"

@interface HYLyricHandleTool : NSObject

+ (NSArray <HYLrcModel *> *)getLyricDataModelWithFileName:(NSString *)fileName;

+ (void)getLyricRowWithTime:(NSTimeInterval)timeInterval lyricModelArray:(NSArray <HYLrcModel *> *)lyricModelArray complection:(void(^)(NSInteger row, HYLrcModel *lyricModel))result;

@end
