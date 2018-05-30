//
//  HYLyricHandleTool.m
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricHandleTool.h"

@implementation HYLyricHandleTool

+ (NSArray<HYLrcModel *> *)getLyricDataModelWithFileName:(NSString *)fileName{
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QQResources" ofType:@"bundle"];
    NSString *filePath = [[path stringByAppendingPathComponent:@"Lrcs"] stringByAppendingPathComponent:fileName];
    if (!filePath) return nil;
    
    NSError *error = nil;
    NSString *lyricStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        [JRToast showWithText:@"读取歌词失败" duration:2];
        return nil;
    }
    
    NSArray *lyricArr = [lyricStr componentsSeparatedByString:@"\n"];
    __block NSMutableArray <HYLrcModel *> *tempArray = [NSMutableArray array];
    //遍历数组，去掉无用信息
    [lyricArr enumerateObjectsUsingBlock:^(NSString *lyricStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //利用正则表达式来获取每一行的歌词
        NSString *pattern = @"\\[[0-9][0-9]:[0-9][0-9].[0-9]{1,}\\]";
        NSError *regularError = nil;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&regularError];
        if (regularError) {
            *stop = YES;
            return;
        }
        NSArray *matchArray = [regular matchesInString:lyricStr options:NSMatchingReportProgress range:NSMakeRange(0, lyricStr.length)];
        HYLrcModel *lyricModel = [HYLrcModel new];
        
        for (NSTextCheckingResult *match in matchArray) {
            
            NSString *timeStr = [lyricStr substringWithRange:match.range];
            //[00:01.79]心碎了无痕
            NSString *lyricContent = [lyricStr componentsSeparatedByString:@"]"].lastObject;
            // 去掉[
            timeStr = [timeStr substringFromIndex:1];
            // 去掉]
            timeStr = [timeStr substringToIndex:(timeStr.length - 1)];
            lyricModel.beginTime = [HYLyricTimeTool getTimeInterval:timeStr];
            lyricModel.lrcStr = lyricContent;
            [tempArray addObject:lyricModel];
        }
    }];
    
    [tempArray enumerateObjectsUsingBlock:^(HYLrcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx != tempArray.count - 1) {
            //将下一个的开始时间设为当前的结束时间
            tempArray[idx].endTime = tempArray[idx + 1].beginTime;
        }
    }];
    
    return tempArray;
}

+ (void)getLyricRowWithTime:(NSTimeInterval)timeInterval lyricModelArray:(NSArray<HYLrcModel *> *)lyricModelArray complection:(void (^)(NSInteger, HYLrcModel *))result{
    
    __block NSInteger row = 0;
    __block HYLrcModel *lyricModel = [[HYLrcModel alloc] init];
    [lyricModelArray enumerateObjectsUsingBlock:^(HYLrcModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (timeInterval >= obj.beginTime && timeInterval <= obj.endTime) {
            
            row = idx;
            lyricModel = obj;
            *stop = YES;
        }
    }];
    
    result(row,lyricModel);
}

@end
