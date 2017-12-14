//
//  HYLiveTopView.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveTopView.h"

@interface HYLiveTopView()

@property (nonatomic,strong) UIView *headerBgView;
@property (nonatomic,strong) UIImageView *headerImgView;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *lookNumLabel;
@property (nonatomic,strong) UIButton *followBtn;

/** 硬币背景 */
@property (nonatomic,strong) UIView *coinBgView;
@property (nonatomic,strong) UILabel *coinNumLabel;
@property (nonatomic,strong) UILabel *inkeIDLabel;


@end

@implementation HYLiveTopView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.headerBgView];
    [self addSubview:self.headerImgView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.lookNumLabel];
    [self addSubview:self.followBtn];
    
    [self addSubview:self.coinBgView];
    [self addSubview:self.coinNumLabel];
}

- (void)layoutSubviews{
    
    [_headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(150 * WIDTH_MULTIPLE, 30 * WIDTH_MULTIPLE));
    }];
    
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.bottom.equalTo(_headerBgView);
        make.width.mas_equalTo(30 * WIDTH_MULTIPLE);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.left.equalTo(_headerImgView.mas_right).offset(8 * WIDTH_MULTIPLE);
        make.height.mas_equalTo(16 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(70 * WIDTH_MULTIPLE);
    }];
    
    [_lookNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_headerBgView);
        make.left.equalTo(_headerImgView.mas_right).offset(8 * WIDTH_MULTIPLE);
        make.height.mas_equalTo(14 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(80 * WIDTH_MULTIPLE);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_headerBgView).offset(-6 * WIDTH_MULTIPLE);
        make.centerY.equalTo(_headerBgView);
        make.size.mas_equalTo(CGSizeMake(36 * WIDTH_MULTIPLE, 22 * WIDTH_MULTIPLE));
    }];
    
    [_coinBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_headerBgView.mas_bottom).offset(10 * WIDTH_MULTIPLE);
        make.left.equalTo(_headerBgView);
        make.size.mas_equalTo(CGSizeMake(140 * WIDTH_MULTIPLE, 20 * WIDTH_MULTIPLE));
    }];
    
    [_coinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(_coinBgView);
        make.left.equalTo(_coinBgView).offset(10 * WIDTH_MULTIPLE);
        make.right.equalTo(_coinBgView).offset(-40 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - lazyload
- (UIView *)headerBgView{
    
    if (!_headerBgView) {
        
        _headerBgView = [UIView new];
        _headerBgView.layer.cornerRadius = 15 * WIDTH_MULTIPLE;
        _headerBgView.backgroundColor = [UIColor darkGrayColor];
        _headerBgView.alpha = 0.4;
    }
    return _headerBgView;
}

- (UIImageView *)headerImgView{
    
    if (!_headerImgView) {
        
        _headerImgView = [UIImageView new];
        _headerImgView.layer.cornerRadius = 15 * WIDTH_MULTIPLE;
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgView.clipsToBounds = YES;
        _headerImgView.image = [UIImage imageNamed:@"ig_home_header_placeholder"];
    }
    return _headerImgView;
}

-(UILabel *)nickNameLabel{
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [UILabel new];
        _nickNameLabel.font = KFitFont(11);
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.text = @"风车大战骑士";

    }
    return _nickNameLabel;
}

- (UILabel *)lookNumLabel{
    
    if (!_lookNumLabel) {
        
        _lookNumLabel = [UILabel new];
        _lookNumLabel.font = KFitFont(10);
        _lookNumLabel.textColor = [UIColor whiteColor];
        _lookNumLabel.textAlignment = NSTextAlignmentLeft;
        _lookNumLabel.text = @"79899";
    }
    return _lookNumLabel;
}

- (UIButton *)followBtn{
    
    if (!_followBtn) {
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor = KAPP_THEME_COLOR;
        _followBtn.layer.cornerRadius = 10 * WIDTH_MULTIPLE;
        _followBtn.clipsToBounds = YES;
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:KAPP_BLACK_COLOR forState:UIControlStateNormal];
        _followBtn.titleLabel.font = KFitFont(12);
    }
    return _followBtn;
}

- (UIView *)coinBgView{
    
    if (!_coinBgView) {
        
        _coinBgView = [UIView new];
        _coinBgView.layer.cornerRadius = 10 * WIDTH_MULTIPLE;
        _coinBgView.backgroundColor = [UIColor darkGrayColor];
        _coinBgView.alpha = 0.4;
    }
    return _coinBgView;
}

- (UILabel *)coinNumLabel{
    
    if (!_coinNumLabel) {
        
        _coinNumLabel = [UILabel new];
        _coinNumLabel.font = KFitFont(13);
        _coinNumLabel.textColor = [UIColor whiteColor];
        _coinNumLabel.textAlignment = NSTextAlignmentLeft;
        _coinNumLabel.text = @"映币: 89489";
    }
    return _coinNumLabel;
}

@end
