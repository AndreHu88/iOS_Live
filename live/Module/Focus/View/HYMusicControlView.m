//
//  HYMusicControlView.m
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicControlView.h"

@interface HYMusicControlView ()

@property (nonatomic, strong) UIButton *loveBtn;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *loopBtn;
@property (nonatomic, strong) UIButton *prevBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *listBtn;

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation HYMusicControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        [self setupMasonryLayout];
    }
    return self;
}

- (void)setupSubviews{
    
    // 顶部
    [self addSubview:self.topView];
    [self.topView addSubview:self.loveBtn];
    [self.topView addSubview:self.downloadBtn];
    [self.topView addSubview:self.commentBtn];
    [self.topView addSubview:self.moreBtn];
    
    // 滑杆
    [self addSubview:self.sliderView];
    [self.sliderView addSubview:self.currentLabel];
    [self.sliderView addSubview:self.totalLabel];
    
    // 底部
    [self addSubview:self.playBtn];
    [self addSubview:self.loopBtn];
    [self addSubview:self.prevBtn];
    [self addSubview:self.nextBtn];
    [self addSubview:self.listBtn];
    
    //
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

- (void)setupMasonryLayout{
    
    // 计算按钮位置
    CGFloat btnWH  = 50;
    CGFloat leftM  = 50;
    CGFloat margin = (KSCREEN_WIDTH - 4 * btnWH - 2 * leftM) / 3;
    
    [self.loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(leftM);
        make.width.mas_equalTo(btnWH);
    }];
    
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topView);
        make.left.equalTo(self.loveBtn.mas_right).offset(margin);
        make.width.mas_equalTo(btnWH);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topView);
        make.left.equalTo(self.downloadBtn.mas_right).offset(margin);
        make.width.mas_equalTo(btnWH);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topView);
        make.left.equalTo(self.commentBtn.mas_right).offset(margin);
        make.width.mas_equalTo(btnWH);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        //            make.top.equalTo(self).offset(30);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    //        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.bottom.equalTo(self.sliderView);
    //            make.left.equalTo(self.sliderView).offset(60);
    //            make.right.equalTo(self.sliderView).offset(-60);
    //        }];
    
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sliderView.mas_left).offset(30);
        make.centerY.equalTo(self.sliderView.mas_centerY);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sliderView.mas_right).offset(30);
        make.centerY.equalTo(self.sliderView.mas_centerY);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
    }];
    
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(20);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
    
    [self.loopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.prevBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
    
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextBtn.mas_right).offset(20);
        make.centerY.equalTo(self.playBtn.mas_centerY);
    }];
}

#pragma mark - setter
- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    self.currentLabel.text = currentTime;
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTime = totalTime;
    
    self.totalLabel.text = totalTime;
}

- (void)setValue:(CGFloat)value {
    _value = value;
}

- (void)setIsLove:(BOOL)isLove {
    _isLove = isLove;
    if (_isLove) {
        [self setupLovedBtn];
    }
    else {
        [self setupLoveBtn];
    }
}

- (void)setupInitialData {
    self.value       = 0;
    self.currentTime = @"00:00";
    self.totalTime   = @"00:00";
    
    //    [self showLoadingAnim];
}

- (void)showLoadingAnim {
    
}

- (void)hideLoadingAnim {
    
    
}

- (void)setupPlayBtn {
    [self.playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
    
    [[HYMusicHandleTool shareInstance].musicTool resumePlayCurrentMusic];
}

- (void)setupPauseBtn {
    [self.playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
    
    [[HYMusicHandleTool shareInstance].musicTool pauseCurrentMusic];

}

- (void)setupLoveBtn {
    
    [self.loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_love"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_love_prs"] forState:UIControlStateHighlighted];
}

- (void)setupLovedBtn {
    [self.loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_loved"] forState:UIControlStateNormal];
    [self.loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_loved_prs"] forState:UIControlStateHighlighted];
}

#pragma mark - UserAction
- (void)loveBtnClick:(id)sender {
    
}

- (void)downloadBtnClick:(id)sender {
    
}

- (void)commentBtnClick:(id)sender {
   
}

- (void)moreBtnClick:(id)sender {
    
}

- (void)playBtnClick:(id)sender {
    if (self.playBtn.selected) {
        [self setupPlayBtn];
    }
    else {
        [self setupPauseBtn];
    }
    self.playBtn.selected = !self.playBtn.selected;
}

- (void)loopBtnClick:(id)sender {
    
}

- (void)prevBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:didClickPrevious:)]) {
        
        [self.delegate controlView:self didClickPrevious:sender];
    }
}

- (void)nextBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlView:didClickNextButton:)]) {
        [self.delegate controlView:self didClickNextButton:sender];
    }
}

- (void)listBtnClick:(id)sender {
    
}


#pragma mark - lazyload
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [UIButton new];
        [_loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_love"] forState:UIControlStateNormal];
        [_loveBtn setImage:[UIImage imageNamed:@"cm2_play_icn_love_prs"] forState:UIControlStateHighlighted];
        [_loveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loveBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton new];
        [_downloadBtn setImage:[UIImage imageNamed:@"cm2_icn_dld"] forState:UIControlStateNormal];
        [_downloadBtn setImage:[UIImage imageNamed:@"cm2_icn_dld_prs"] forState:UIControlStateHighlighted];
        [_downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt"] forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt_prs"] forState:UIControlStateHighlighted];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn setImage:[UIImage imageNamed:@"cm2_play_icn_more"] forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"cm2_play_icn_more_prs"] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)loopBtn {
    if (!_loopBtn) {
        _loopBtn = [UIButton new];
        [_loopBtn setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
        [_loopBtn setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
        [_loopBtn addTarget:self action:@selector(loopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loopBtn;
}

- (UIButton *)prevBtn {
    if (!_prevBtn) {
        _prevBtn = [UIButton new];
        [_prevBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_previous"] forState:UIControlStateNormal];
        [_prevBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_previous_prs"] forState:UIControlStateHighlighted];
        [_prevBtn addTarget:self action:@selector(prevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prevBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [UIButton new];
        [_listBtn setImage:[UIImage imageNamed:@"cm2_icn_list"] forState:UIControlStateNormal];
        [_listBtn setImage:[UIImage imageNamed:@"cm2_icn_list_prs"] forState:UIControlStateHighlighted];
        [_listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [UIView new];
        _sliderView.backgroundColor = [UIColor clearColor];
    }
    return _sliderView;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _currentLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _totalLabel;
}

@end
