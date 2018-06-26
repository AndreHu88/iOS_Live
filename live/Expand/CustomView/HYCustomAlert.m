//
//  HYCustomAlert.m
//  DaCongMing
//
//  Created by 胡勇 on 2017/9/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYCustomAlert.h"

@interface HYCustomAlert()

/** 半透明背景 */
@property (nonatomic,strong) UIView *blackBgView;
/** 白色背景 */
@property (nonatomic,strong) UIView *bgView;
/** title */
@property (nonatomic,strong) UILabel *titleLabel;
/** contentLabel */
@property (nonatomic,strong) UILabel *contentLabel;
/** 取消 */
@property (nonatomic,strong) UIButton *cancelBtn;
/** 确定 */
@property (nonatomic,strong) UIButton *confirmBtn;
/** horLine */
@property (nonatomic,strong) UIView *horLine;
/** line */
@property (nonatomic,strong) UIView *line;

@end


@implementation HYCustomAlert

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title content:(NSString *)content confirmBlock:(void(^)())confirmAction{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _titleLabel.text = title;
        _contentLabel.text = content;
        self.actionBlock = confirmAction;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            [self layoutIfNeeded];
            CGPoint tapPoint = [sender locationInView:self];
            if (!CGRectContainsPoint(_bgView.frame, tapPoint)) {
                
                [self hideCustomAlert];
            }
        }];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.blackBgView];
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.line];
    [self addSubview:self.horLine];
    
}

- (void)layoutSubviews{
    
    [_blackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(KSCREEN_WIDTH - 100 * WIDTH_MULTIPLE, 180 * WIDTH_MULTIPLE));
        make.center.equalTo(self);
    }];

    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_bgView).offset(20 * WIDTH_MULTIPLE);
        make.left.right.equalTo(_bgView);
        make.height.equalTo(@(20 * WIDTH_MULTIPLE));
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(_bgView).offset(-5 * WIDTH_MULTIPLE);
        make.left.right.equalTo(_bgView);
        make.height.equalTo(@(40 * WIDTH_MULTIPLE));
    }];

    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(_bgView).offset(3);
        make.bottom.equalTo(_bgView).offset(-3);
        make.height.equalTo(@(40 * WIDTH_MULTIPLE));
        make.width.equalTo(@(120 * WIDTH_MULTIPLE));
    }];

    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(_bgView).offset(-3);
        make.bottom.equalTo(_bgView).offset(-3);
        make.width.height.equalTo(_cancelBtn);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_bgView);
        make.width.equalTo(@1);
        make.top.equalTo(_cancelBtn);
        make.left.equalTo(self).offset(KSCREEN_WIDTH / 2);
    }];

    [_horLine mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.equalTo(_bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(_cancelBtn);
    }];
}

#pragma mark - action
- (void)cancelBtnAction{
    
    [self removeFromSuperview];
}

- (void)confirmBtnAction{
    
    [self removeFromSuperview];
    self.actionBlock();
}

#pragma mark - public
- (void)showCustomAlert{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //_blackBgView.alpha = 0.6;
    }];
}

- (void)hideCustomAlert{
    
    _blackBgView.alpha = 0;
    [self removeFromSuperview];
}

#pragma mark - lazyload
- (UIView *)blackBgView{
    
    if (!_blackBgView) {
        
        _blackBgView = [UIView new];
        _blackBgView.backgroundColor = KAPP_BLACK_COLOR;
        _blackBgView.alpha = 0;
    }
    return _blackBgView;
}

- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [UIView new];
        _bgView.backgroundColor = KAPP_WHITE_COLOR;
        _bgView.layer.cornerRadius = 6 * WIDTH_MULTIPLE;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = KFitFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"温馨提示";
        _titleLabel.textColor = KAPP_272727_COLOR;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = KFitFont(18);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"温馨提示好啊好啊";
        _contentLabel.textColor = KAPP_272727_COLOR;
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn{
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = KAPP_WHITE_COLOR;
        [_cancelBtn setTitleColor:KAPP_272727_COLOR forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = KFitFont(16);
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn{
    
    if (!_confirmBtn) {
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = KAPP_WHITE_COLOR;
        [_confirmBtn setTitleColor:KAPP_THEME_COLOR forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = KFitFont(16);
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)line{
    
    if (!_line) {
        
        _line = [UIView new];
        _line.backgroundColor = KAPP_SEPERATOR_COLOR;
        
        _horLine = [UIView new];
        _horLine.backgroundColor = KAPP_SEPERATOR_COLOR;
    }
    return _line;
}

@end
