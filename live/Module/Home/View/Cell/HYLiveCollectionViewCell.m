//
//  HYLiveCollectionViewCell.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveCollectionViewCell.h"

@interface HYLiveCollectionViewCell ()

/** 背景图 */
@property (nonatomic,strong) UIImageView *bgImgView;
/** 毛玻璃 */
@property (nonatomic,strong) UIVisualEffectView *visualView;
/** 播放器 */
@property (nonatomic,strong) IJKFFMoviePlayerController * player;
/** viewModel */
@property (nonatomic,strong) HYLiveViewModel *viewModel;

@end

@implementation HYLiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.bgImgView];
}

- (void)dealloc{
    
    [self removeNotification];
}

#pragma mark - addNotification
- (void)addNotification{
    
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
}

- (void)removeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
}

#pragma mark - Notification CallBack
- (void)didFinish{
    
    DLog(@"---播放完成了");
    [JRToast showWithText:@"直播完成了" duration:2.0];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    self.viewModel.isPlaying = NO;
    switch (self.player.playbackState){
            
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            self.viewModel.isPlaying = YES;
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}


#pragma mark - setter
- (void)setCurrentLiveModel:(HYHotLiveModel *)currentLiveModel{
    
    _currentLiveModel = currentLiveModel;
    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:currentLiveModel.creator.portrait] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
}

- (void)setWithViewModel:(HYLiveViewModel *)viewModel{
    
    self.viewModel = viewModel;
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    [self removeNotification];
    self.player = nil;
    
    [IJKFFMoviePlayerController setLogReport:NO];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //设置解码的方式
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.currentLiveModel.stream_addr] withOptions:options];
    self.player.view.frame = self.bounds;
    self.player.shouldAutoplay = YES;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    [self.player prepareToPlay];
    [self.player setPauseInBackground:YES];
    [self addSubview:self.player.view];
    [self addNotification];
    viewModel.player = self.player;
    viewModel.targetID = @"ChatRoom01";
    viewModel.stream_url = self.currentLiveModel.stream_addr;
    
    /**
     k_IJK_LOG_VERBOSE = 2,//较为啰嗦的log等级
     k_IJK_LOG_DEBUG   = 3,
     k_IJK_LOG_INFO    = 4,
     k_IJK_LOG_WARN    = 5,
     k_IJK_LOG_ERROR   = 6,//普通错误
     k_IJK_LOG_FATAL   = 7,//毁灭性的错误
     k_IJK_LOG_SILENT  = 8,//静默 什么log都不输出
     */
    
    //先去设置一下是否打印log，有利于我们去查看信息，但是正式情况下，最好关闭打印
#ifdef DEBUG
//    [IJKFFMoviePlayerController setLogReport:YES];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_SILENT];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
}

#pragma mark - lazyload
-(UIImageView *)bgImgView{
    
    if (!_bgImgView) {
        
        _bgImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:self.currentLiveModel.creator.portrait] placeholderImage:[UIImage imageNamed:@"default_room"]];
        //设置毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //创建毛玻璃视图
        _visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _visualView.frame = _bgImgView.bounds;
        [_bgImgView addSubview:self.visualView];
        
    }
    return _bgImgView;
}

- (IJKFFMoviePlayerController *)player{
    
    if (!_player) {
        
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        //设置解码的方式
        [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.currentLiveModel.stream_addr] withOptions:options];
        _player.view.frame = self.bounds;
        _player.shouldAutoplay = YES;
        [_player prepareToPlay];
    }
    return _player;
}

@end
