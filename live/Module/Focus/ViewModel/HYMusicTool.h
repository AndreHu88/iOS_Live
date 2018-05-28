//
//  HYMusicTool.h
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HYMusicTool : NSObject

/** 音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;

/**
 *  播放指定文件的音乐
 *
 *  @param musicName 音乐文件名
 */
- (BOOL)playMusic:(NSString *)musicName;

@end
