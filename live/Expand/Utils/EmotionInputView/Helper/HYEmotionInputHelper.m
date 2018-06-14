//
//  HYEmotionInputHelper.m
//  live
//
//  Created by Duntech on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYEmotionInputHelper.h"

@implementation HYEmotionInputHelper

+ (NSBundle *)resourceBundle{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
}

+ (YYMemoryCache *)imageCache{
    
    YYMemoryCache *imageCache = [YYMemoryCache new];
    imageCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    imageCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    imageCache.name = @"WeiboImageCache";
    return imageCache;
}

+ (UIImage *)emotionImageNamed:(NSString *)imageName{
    
    if (!imageName) return nil;
    UIImage *image = [[self imageCache] objectForKey:imageName];
    if (image) return image;
    NSString *ext = imageName.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self resourceBundle] pathForScaledResource:imageName ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    image = [image imageByDecoded];
    [[self imageCache] setObject:image forKey:imageName];
    return image;
}

+ (NSArray <HYEmotionGroupModel *> *)emotionGroups{
    
    NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
    NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"emoticons.plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
    NSArray *packages = plist[@"packages"];
    NSMutableArray *groupsArray = (NSMutableArray *)[NSArray modelArrayWithClass:[HYEmotionGroupModel class] json:packages];
    
    NSMutableDictionary *groupDic = [NSMutableDictionary new];
    for (NSInteger i = 0 , maxCount = groupsArray.count; i < maxCount; i++) {
        
        HYEmotionGroupModel *emotionGroupModel = groupsArray[i];
        if (emotionGroupModel.id.length == 0) {
            [groupsArray removeObject:emotionGroupModel];
            i--;
            maxCount--;
            continue;
        }
        NSString *path = [emoticonBundlePath stringByAppendingPathComponent:emotionGroupModel.id];
        NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
        [emotionGroupModel modelSetWithDictionary:info];
        if (emotionGroupModel.emotions.count == 0) {
            i--;
            maxCount--;
            continue;
        }
        
        [groupDic setObject:emotionGroupModel forKey:emotionGroupModel.id];
    }
    
    return groupsArray;
}

@end
