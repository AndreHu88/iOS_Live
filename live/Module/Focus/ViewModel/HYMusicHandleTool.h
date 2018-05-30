//
//  HYMusicHandleTool.h
//  live
//
//  Created by Duntech on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMusicModel.h"
#import "HYMusicPlayInfoModel.h"
#import "HYMusicTool.h"

@interface HYMusicHandleTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray <HYMusicModel *> *musicList;
@property (nonatomic,strong) HYMusicTool *musicTool;


- (HYMusicModel *)getCurrentMusicModel;

- (HYMusicModel *)previousMusicModel;

- (HYMusicModel *)nextMusicModel;

- (HYMusicPlayInfoModel *)getCurrentMusicPlayInfoModel;

- (BOOL)playMusicWithModel:(HYMusicModel *)model;

- (void)playCurrentMusic;

- (void)pauseCurrentMusic;

- (void)playNextMusic;

- (void)playPreviousMusic;

@end
