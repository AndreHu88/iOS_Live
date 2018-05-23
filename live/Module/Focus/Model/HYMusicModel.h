//
//  HYMusicModel.h
//  live
//
//  Created by Duntech on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYMusicModel : NSObject

/** 歌曲名称*/
@property (nonatomic, copy) NSString *name;

/** 演唱者*/
@property (nonatomic, strong) NSString *singer;

/** 歌手头像*/
@property (nonatomic, strong) NSString *singerIcon;

/** 歌词文件名称*/
@property (nonatomic, strong) NSString *lrcname;

/** 歌曲文件名称*/
@property (nonatomic, strong) NSString *filename;

/** 专辑图片*/
@property (nonatomic, strong) NSString *icon;

@end
