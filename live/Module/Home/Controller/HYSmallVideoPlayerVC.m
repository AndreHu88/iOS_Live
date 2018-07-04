//
//  HYSmallVideoPlayerVC.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYSmallVideoPlayerVC.h"
#import "HYLiveBottomView.h"
#import "HYSmallVideoViewModel.h"
#import "HYImageTransition.h"


@interface HYSmallVideoPlayerVC ()

/** 底部按钮 */
@property (nonatomic,strong) HYLiveBottomView *bottomView;
/** viewModel */
@property (nonatomic,strong) HYSmallVideoViewModel *viewModel;
/** 转场的delegate */
@property (nonatomic,strong) HYImageTransition *transition;
/** 播放器 */
@property (nonatomic,strong) IJKFFMoviePlayerController *player;

@end

@implementation HYSmallVideoPlayerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubviews];
    [self bindViewModel];
    [self addNotification];
}

- (void)dealloc{
    
    [self removeNotification];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [_player shutdown];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)setupSubviews{
    
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.player.view];
    [self.view addSubview:self.bottomView];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)bindViewModel{
    
    self.viewModel = [[HYSmallVideoViewModel alloc] init];
    [self.bottomView setWithSmallVideoViewModel:_viewModel];
    
    [self.viewModel.quitPlayerSubject subscribeNext:^(id x) {
       
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidLayoutSubviews{
    
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(-20 * WIDTH_MULTIPLE);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - action
- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint currentPoint = [pan locationInView:self.view];
    CGFloat precent = translation.y / KSCREEN_HEIGHT;
    precent = precent < 0 ? 0 : precent;
    precent = precent > 1 ? 1 : precent;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            
            if ([self.player isPlaying]) [self.player stop];
            //1. 设置代理
            self.transition = nil;
            self.navigationController.delegate = self.transition;
            //小视频页面的截图
            self.transition.screenShotImg = self.snapImage;
            //转场之前的frame
            self.transition.afterFrame = self.beforeImageViewFrame;
            self.transition.beforeFrame = self.view.bounds;
            self.transition.transitionBeforeImgView = self.bgImgView;
            self.transition.pan = pan;
            self.tabBarController.tabBar.hidden = NO;
            self.bottomView.hidden = self.player.view.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            self.bgImgView.center = CGPointMake(currentPoint.x, currentPoint.y);
            self.bgImgView.transform = CGAffineTransformMakeScale(1 - precent * 1.2, 1 - precent * 1.2);
            self.transition.beforeFrame = self.bgImgView.frame;
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            if (precent > 0.25) {
                

            }
            else{
                
                //继续播放视频
                self.player.view.hidden = NO;
                self.bgImgView.transform = CGAffineTransformIdentity;
                self.bgImgView.frame = [UIScreen mainScreen].bounds;
                [self.player play];
            }
            self.navigationController.delegate = self.transition;
            self.bottomView.hidden = self.player.view.hidden = NO;
        
            break;
        default:
            break;
    }
}

#pragma mark - setter
- (void)setModel:(HYSmallVideoModel *)model{
    
    _model = model;
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
    [_player prepareToPlay];
    [_player play];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (self.player.playbackState){
            
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
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


#pragma mark - lazyload
- (UIImageView *)bgImgView{
    
    if (!_bgImgView) {
        
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }
    return _bgImgView;
}

- (HYLiveBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [HYLiveBottomView new];
    }
    return _bottomView;
}

- (HYImageTransition *)transition{
    
    if (!_transition) {
        
        _transition = [HYImageTransition new];
    }
    return _transition;
}

- (IJKFFMoviePlayerController *)player{
    
    if (!_player) {
        
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        //设置解码的方式
        [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.model.contentInfo.mp4_url] withOptions:options];
        _player.view.frame = self.view.bounds;
        _player.shouldAutoplay = YES;
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
        [_player prepareToPlay];
        [_player play];
        [_player setPauseInBackground:YES];
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
