//
//  HYMusicHandleTool.h
//  live
//
//  Created by Duntech on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMusicModel.h"

@interface HYMusicHandleTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray <HYMusicModel *> *musicList;

- (HYMusicModel *)getCurrentMusicModel;

- (HYMusicModel *)previousMusicModel;

- (HYMusicModel *)nextMusicModel;

- (BOOL)playMusicWithModel:(HYMusicModel *)model;

- (void)playCurrentMusic;

- (void)pauseCurrentMusic;

- (BOOL)playNextMusic;

- (BOOL)playPreviousMusic;

- (void)seekToTime:(NSTimeInterval)timeInterval;

@end
