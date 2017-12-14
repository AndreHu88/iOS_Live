//
//  HYChatInputView.m
//  live
//
//  Created by Jack on 2017/12/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYChatInputView.h"

@interface HYChatInputView() <UITextFieldDelegate>

/** 毛玻璃 */
@property (nonatomic,strong) UIVisualEffectView *visualView;
/** 发送按钮 */
@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation HYChatInputView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KAPP_WHITE_COLOR;
        self.alpha = 0.9;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.visualView];
    [self addSubview:self.textField];
    [self addSubview:self.sendBtn];
}

- (void)layoutSubviews{
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(60 * WIDTH_MULTIPLE);
        make.right.equalTo(self).offset(-90 * WIDTH_MULTIPLE);
        make.top.bottom.equalTo(self);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(60 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - sendBtnAction
- (void)sendBtnAction{
    
    if (![self.textField.text isNotBlank]) {
        
        return;
    }
    
    if (self.delegate && [_delegate respondsToSelector:@selector(sendButtonTaped:)]) {
        
        [_delegate sendButtonTaped:self.textField.text];
    }
}

- (void)clearInputContent{
    
    self.textField.text = @"";
}

#pragma mark - lazyload
- (UIVisualEffectView *)visualView{
    
    if (!_visualView) {
        
        //设置毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //创建毛玻璃视图
        _visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _visualView.frame = self.bounds;
    }
    return _visualView;
}

- (UITextField *)textField{
    
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"和大家说点什么" attributes:@{NSForegroundColorAttributeName:KAPP_7b7b7b_COLOR,NSFontAttributeName : KFitFont(15)}];
        _textField.font = KFitFont(15);
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.textColor = KAPP_272727_COLOR;
        _textField.tintColor = KAPP_THEME_COLOR;
        _textField.inputAccessoryView = [[UIView alloc] init];
    }
    return _textField;
}

- (UIButton *)sendBtn{
    
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发 送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:KAPP_THEME_COLOR forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = KFitBoldFont(15);
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
