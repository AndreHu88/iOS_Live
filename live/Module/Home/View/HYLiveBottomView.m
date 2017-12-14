//
//  HYLiveBottomView.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveBottomView.h"

@interface HYLiveBottomView()

@property (nonatomic,strong) UIButton *chatBtn;
@property (nonatomic,strong) UIButton *messageBtn;
@property (nonatomic,strong) UIButton *giftBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UIButton *closeBtn;
/** 数字badge */
@property (nonatomic,strong) PPBadgeLabel *badgeLabel;

@end

@implementation HYLiveBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.chatBtn];
    [self addSubview:self.messageBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.closeBtn];
    [self addSubview:self.badgeLabel];

}

- (void)layoutSubviews{
    
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(40 * WIDTH_MULTIPLE);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-10 * WIDTH_MULTIPLE);
        make.top.height.width.equalTo(_chatBtn);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_closeBtn.mas_left).offset(-10 * WIDTH_MULTIPLE);
        make.top.height.width.equalTo(_chatBtn);
    }];
    
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_shareBtn.mas_left).offset(-10 * WIDTH_MULTIPLE);
        make.top.height.width.equalTo(_chatBtn);
    }];
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_giftBtn.mas_left).offset(-10 * WIDTH_MULTIPLE);
        make.top.height.width.equalTo(_chatBtn);
    }];
    
    [self layoutIfNeeded];
    _badgeLabel.p_centerX = _messageBtn.imageView.center.x + _messageBtn.left;
    _badgeLabel.p_centerY = _messageBtn.imageView.center.y + _messageBtn.left;
}

#pragma mark - setViewModel
- (void)setWithViewModel:(HYLiveViewModel *)viewModel{
    
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribe:viewModel.closeLiveSubject];
    [[_chatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribe:viewModel.chatSubject];
}

- (void)setWithSmallVideoViewModel:(HYSmallVideoViewModel *)smallVideoViewModel{
    
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribe:smallVideoViewModel.quitPlayerSubject];
}

#pragma mark - lazyload
- (UIButton *)chatBtn{
    
    if (!_chatBtn) {
        
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@"room_pub_chat"] forState:UIControlStateNormal];
    }
    return _chatBtn;
}

- (UIButton *)messageBtn{
    
    if (!_messageBtn) {
        
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"room_private_chat"] forState:UIControlStateNormal];
        
    }
    return _messageBtn;
}

- (UIButton *)giftBtn{
    
    if (!_giftBtn) {
        
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage imageNamed:@"ig_room_btn_liwu"] forState:UIControlStateNormal];
    }
    return _giftBtn;
}

- (UIButton *)shareBtn{
    
    if (!_shareBtn) {
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"room_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIButton *)closeBtn{
    
    if (!_closeBtn) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"room_quit"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (PPBadgeLabel *)badgeLabel{
    
    if (!_badgeLabel) {
        
        _badgeLabel = [PPBadgeLabel defaultBadgeLabel];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.text = @"2";
    }
    return _badgeLabel;
}

@end
