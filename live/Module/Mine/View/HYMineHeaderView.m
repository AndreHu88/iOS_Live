//
//  HYMineHeaderView.m
//  live
//
//  Created by 胡勇 on 2018/7/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMineHeaderView.h"

@interface HYMineHeaderView ()

@property (nonatomic,strong) UIImageView *headerImgView;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *introLabel;
@property (nonatomic,strong) UIImageView *genderImgView;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *settingBtn;
@property (nonatomic,strong) UIButton *messageBtn;

@end

@implementation HYMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KAPP_WHITE_COLOR;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.headerImgView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.introLabel];
    [self addSubview:self.line];
    [self addSubview:self.settingBtn];
    [self addSubview:self.messageBtn];
}

- (void)layoutSubviews{
    
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(80 * WIDTH_MULTIPLE, 80 * WIDTH_MULTIPLE));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgView);
        make.top.equalTo(_headerImgView.mas_bottom).offset(15 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(200, 35 * WIDTH_MULTIPLE));
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgView);
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(15 * WIDTH_MULTIPLE);
        make.right.equalTo(self).offset(-15 * WIDTH_MULTIPLE);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(_headerImgView);
        make.right.offset(-15 * WIDTH_MULTIPLE);
    }];
    
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30 * WIDTH_MULTIPLE, 30 * WIDTH_MULTIPLE));
        make.right.offset(-25 * WIDTH_MULTIPLE);
        make.centerY.equalTo(_headerImgView);
    }];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(_messageBtn);
        make.right.equalTo(_messageBtn.mas_left).offset(-25 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - Setter


#pragma mark - action
- (void)settingBtnAction{
    
    if (self.settingActionBlock) {
        self.settingActionBlock();
    }
}

- (void)messageBtnAction{
    
    if (self.messageActionBlock) {
        self.messageActionBlock();
    }
}

#pragma mark - lazyload
- (UIImageView *)headerImgView{
    
    if (!_headerImgView) {
        
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 40 * WIDTH_MULTIPLE;
        _headerImgView.clipsToBounds = YES;
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:@"https://upload.jianshu.io/users/upload_avatars/4499332/2eb7e5b4-a2ab-4d08-9910-07ef7e1d23e0.jpg"] placeholderImage:[UIImage imageNamed:@"dynamic_man"]];
//        _headerImgView.image = [UIImage imageNamed:@"dynamic_man"];
        _headerImgView.userInteractionEnabled = YES;
    }
    return _headerImgView;
}

- (UILabel *)nickNameLabel{
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [UILabel new];
        _nickNameLabel.font = KFitBoldFont(23);
        _nickNameLabel.textColor = KAPP_BLACK_COLOR;
        _nickNameLabel.text = @"风车大战骑士";
    }
    return _nickNameLabel;
}

- (UIImageView *)genderImgView{
    
    if (!_genderImgView) {
        _genderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dynamic_location"]];
        _genderImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _genderImgView;
}

- (UILabel *)introLabel{
    
    if (!_introLabel) {
        _introLabel = [UILabel new];
        _introLabel.font = KFitFont(12);
        _introLabel.textColor = UIColorHex(9e9e9e);
        _introLabel.text = @"我很懒，什么都没有写";
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}


- (UIButton *)settingBtn{
    
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}

- (UIButton *)messageBtn{
    
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"news_pre"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}


- (UIView *)line{
    
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = KCOLOR(@"c3c3c3");
    }
    return _line;
}

@end
