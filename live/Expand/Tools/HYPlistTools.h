//
//  HYPlistTools.h
//  DaCongMing
//
//  Created by 胡勇 on 2017/9/28.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPlistTools : NSObject

/**写入plist文件*/
+ (void)saveDataWithPlistName:(NSString *)plistName dataArray:(NSArray *)dataArray;

/**将自定义的对象存入plist文件*/
+ (void)archiveObject:(id)object withName:(NSString *)name;

/**将自定义的对象解档*/
+ (id)unarchivewithName:(NSString *)name;

/**判断某个文件是否存在*/
+ (BOOL)isFileExistWithFileName:(NSString *)fileName;

/**读取数组plist文件*/
+ (NSArray *)getArrayDataWithPlistName:(NSString *)plistName;

/**读取bundle字典plist文件*/
+ (NSDictionary *)getDictionaryDataInBundleWithPlistName:(NSString *)plistName;

/**读取沙盒字典plist文件*/
+ (NSDictionary *)getDictionaryDataWithPlistName:(NSString *)plistName;

/**移除plist文件*/
+ (void)removeDataWithName:(NSString *)name;

/**计算某个文件夹下容量*/
+ (CGFloat )folderSizeAtPath:(NSString *)folderPath;

/**清除缓存*/
+ (void)clearCachesAtPath:(NSString *)path;

@end
