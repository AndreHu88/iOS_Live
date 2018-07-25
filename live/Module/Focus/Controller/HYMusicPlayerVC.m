//
//  HYMusicPlayerVC.m
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicPlayerVC.h"
#import "HYMusicHandleTool.h"
#import "HYMusicPlayerDiscView.h"
#import "HYLyricView.h"
#import "HYMusicControlView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HYMusicPlayerVC () <HYMusicPlayerDiscViewDelegate,HYMusicControlViewDelegate>

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) HYMusicPlayerDiscView *discView;
@property (nonatomic,strong) YYLabel *titleLabel;
@property (nonatomic,strong) HYLyricView *lyricView;
@property (nonatomic,strong) HYMusicControlView *musicControlView;
/** 歌词定时器*/
@property (nonatomic, weak) CADisplayLink *displayLink;

@end

@implementation HYMusicPlayerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubViews];
    [self addDisplayLink];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setupNav];
    [self setupLockScreenControlInfo];
}

- (void)setupNav{
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:KAPP_WHITE_COLOR];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}


- (void)setupSubViews{
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.musicControlView];
    [self.view addSubview:self.discView];
    [self.view addSubview:self.lyricView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    [_musicControlView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(170 * WIDTH_MULTIPLE);
    }];
    
    [_lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.discView);
    }];
    
    [_discView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLyricView)]];
    [_lyricView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDiscView)]];
    
}

- (void)setupLockScreenControlInfo{
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTarget:self action:@selector(controlViewPauseMusic)];
    
    commandCenter.pauseCommand.enabled = YES;
    [commandCenter.pauseCommand addTarget:self action:@selector(controlViewPauseMusic)];
    
    commandCenter.nextTrackCommand.enabled = YES;
    [commandCenter.nextTrackCommand addTarget:self action:@selector(playNext)];
    
    commandCenter.previousTrackCommand.enabled = YES;
    [commandCenter.previousTrackCommand addTarget:self action:@selector(playPrevious)];
    
    commandCenter.togglePlayPauseCommand.enabled = YES;
}

- (void)updateLockScreenControlInfo{
    
//    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
//    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
//    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@""]];
//    infoCenter.nowPlayingInfo = @{};
}

#pragma mark - action
- (void)playNext{
    
    
}

- (void)playPrevious{
    
    
}

- (void)showLyricView{
    
    self.lyricView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
       
        self.lyricView.alpha = 1;
        self.discView.alpha = 0;
        
    } completion:^(BOOL finished) {
       
        self.discView.hidden = YES;
    }];
}

- (void)showDiscView{
    
    self.discView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.lyricView.alpha = 0;
        self.discView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        self.lyricView.hidden = YES;
    }];
}

- (void)updateLrc{
    
   //获取当前的播放时长
    HYMusicPlayInfoModel *musicInfoModel = [[HYMusicHandleTool shareInstance] getCurrentMusicPlayInfoModel];
    [HYLyricHandleTool getLyricRowWithTime:musicInfoModel.currentPlayTime lyricModelArray:self.lyricView.lyricDataSource complection:^(NSInteger row, HYLrcModel *lyricModel) {
        
        self.lyricView.scrollRow = row;
        //歌词进度
        CGFloat progress = (musicInfoModel.currentPlayTime - lyricModel.beginTime) / (lyricModel.endTime - lyricModel.beginTime);
        self.lyricView.progress = progress;
    }];
    
    self.musicControlView.sliderValue = musicInfoModel.currentPlayTime / musicInfoModel.totalTime;
    self.musicControlView.currentTime = [HYLyricTimeTool getFormatTimeWithInterval:musicInfoModel.currentPlayTime];
}

/** 定时更新 歌词面板信息*/
- (void)addDisplayLink{
    
    if (!_displayLink) {
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
        self.displayLink = displayLink;
        // 添加到 runloop
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - setter
- (void)setMusicModel:(HYMusicModel *)musicModel{
    
    _musicModel = musicModel;
    [[HYMusicHandleTool shareInstance] playMusicWithModel:musicModel];
    self.discView.musicModel = musicModel;
    
    [self setTitleLabelWithModel:musicModel];
    [self setLyricWithModel:musicModel];
    [self.musicControlView setupPlayBtn];
    [self setMusicControlWithModel:musicModel];
}

- (void)setXiamiMusicModel:(HYXiaMiMusicModel *)xiamiMusicModel{
    
    _xiamiMusicModel = xiamiMusicModel;
}

- (void)setTitleLabelWithModel:(HYMusicModel *)musicModel{
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@",musicModel.name,musicModel.singer];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : KAPP_WHITE_COLOR}];
    [attributeStr addAttributes:@{NSFontAttributeName : KFitFont(13)} range:NSMakeRange(0, musicModel.name.length)];
    [attributeStr addAttributes:@{NSFontAttributeName : KFitFont(11)} range:NSMakeRange(musicModel.name.length, musicModel.singer.length)];
    [attributeStr setAlignment:NSTextAlignmentCenter];
    
    YYTextHighlight *sinerText = [[YYTextHighlight alloc] init];
    [attributeStr setTextHighlight:sinerText range:NSMakeRange(musicModel.name.length, musicModel.singer.length)];
    sinerText.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        [JRToast showWithText:[NSString stringWithFormat:@"tap %@",text.string] duration:2];
    };
    self.titleLabel.attributedText = attributeStr;
    self.navigationItem.titleView = self.titleLabel;
}

- (void)setLyricWithModel:(HYMusicModel *)musicModel{
    
    NSArray *lyricModelArray = [HYLyricHandleTool getLyricDataModelWithFileName:musicModel.lrcname];
    self.lyricView.lyricDataSource = lyricModelArray;
}

- (void)setMusicControlWithModel:(HYMusicModel *)musicModel{
    
    self.musicControlView.totalTime = [HYLyricTimeTool getFormatTimeWithInterval:[[HYMusicHandleTool shareInstance] getCurrentMusicPlayInfoModel].totalTime];
    self.musicControlView.currentTime = [HYLyricTimeTool getFormatTimeWithInterval:[[HYMusicHandleTool shareInstance] getCurrentMusicPlayInfoModel].currentPlayTime];
}

#pragma mark - discViewDelegate
- (void)discViewWillChangeModel:(HYMusicModel *)musicModel{
    
    
}

- (void)discViewDidChangeModel:(HYMusicModel *)musicModel{
    
    self.musicModel = musicModel;
}

#pragma mark - HYMusicControlViewDelegate
- (void)controlView:(HYMusicControlView *)controlView didClickPrevious:(UIButton *)previousMusicButton{
    
    HYMusicModel *musicModel = [[HYMusicHandleTool shareInstance] previousMusicModel];
    self.musicModel = musicModel;
}

- (void)controlView:(HYMusicControlView *)controlView didClickNextButton:(UIButton *)NextMusicButton{
    
    HYMusicModel *musicModel = [[HYMusicHandleTool shareInstance] nextMusicModel];
    self.musicModel = musicModel;
}

- (void)controlViewPauseMusic{
    
    [self.discView pauseMusicWithAnimated:YES];
}

- (void)controlViewResumePlayMusic{
    
    [self.discView playedWithAnimated:YES];
}

- (void)controlView:(HYMusicControlView *)controlView didChangePlayTime:(CGFloat)currentPlayTIme{
    
    //调整歌词
    [HYLyricHandleTool getLyricRowWithTime:currentPlayTIme lyricModelArray:self.lyricView.lyricDataSource complection:^(NSInteger row, HYLrcModel *lyricModel) {
        
        self.lyricView.scrollRow = row;
        //歌词进度
        CGFloat progress = (currentPlayTIme - lyricModel.beginTime) / (lyricModel.endTime - lyricModel.beginTime);
        self.lyricView.progress = progress;
    }];
}

#pragma mark - lazyload
- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        // 添加模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.view.bounds;
        [_bgImageView addSubview:effectView];
    }
    return _bgImageView;
}

- (HYMusicPlayerDiscView *)discView{
    
    if (!_discView) {
        
        _discView = [[HYMusicPlayerDiscView alloc] initWithFrame:CGRectMake(0, KIs_iPhoneX ?  : 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 170 * WIDTH_MULTIPLE - (KIs_iPhoneX ? 88 : 64))];
        _discView.delegate = self;
    }
    return _discView;
}

- (YYLabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _titleLabel.centerX = self.view.centerX;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = KAPP_WHITE_COLOR;
    }
    return _titleLabel;
}

- (HYMusicControlView *)musicControlView{
    
    if (!_musicControlView) {
        
        _musicControlView = [HYMusicControlView new];
        _musicControlView.delegate = self;
    }
    return _musicControlView;
}

- (HYLyricView *)lyricView{
    
    if (!_lyricView) {
        _lyricView = [[HYLyricView alloc] init];
        _lyricView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _lyricView.scrollLyricBlock = ^(CGFloat scrollTime) {
            
            [weakSelf updateLrc];
        };
    }
    return _lyricView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
