//
//  HYMusicTool.m
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicTool.h"

@interface HYMusicTool () <AVAudioPlayerDelegate>


@end

@implementation HYMusicTool

- (instancetype)init{
    
    if (self == [super init]) {
        
        // 1.获取音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        // 2.设置音频会话类别
        NSError *error = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            [JRToast showWithText:@"创建音频回话失败"];
            return nil;
        }
        [session setActive:YES error:&error];
        if (error) {
            [JRToast showWithText:@"创建音频回话失败"];
            return nil;
        }
        
    }
    return self;
}

- (BOOL)playMusic:(NSString *)musicName{
    
    // 判断路径是否正确
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QQResources" ofType:@"bundle"];
    NSString *filePath = [[path stringByAppendingPathComponent:@"MP3s"] stringByAppendingPathComponent:musicName];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (!url) {
        return NO;
    }
    
    // 判断是否播放同一首歌曲
    if (self.player.url && [self.player.url isEqual:url]) {
        
        if (!self.player.isPlaying) {
            [self.player play]; // 为了暂停后, 能够再播放
        }
        return NO;
    }
    
    // 1.创建 player
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player.delegate = self;
    [self.player play];
    if (error) {
        NSLog(@"%@", error);
        [JRToast showWithText:error.description];
        return NO;
    }
    
    return YES;
}

- (void)pauseCurrentMusic{
    
    [self.player pause];
}

- (void)stopCurrentMusic{
    
    [self.player stop];
}

- (void)resumePlayCurrentMusic{
    
    [self.player play];
}

- (void)seekTo:(NSTimeInterval)timeInteval{
    
    self.player.currentTime = timeInteval;
}

#pragma mark - AudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    DLog(@"歌曲播放完成");
}

@end
