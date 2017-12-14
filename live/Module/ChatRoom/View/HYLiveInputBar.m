//
//  HYLiveInputBar.m
//  live
//
//  Created by Jack on 2017/12/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveInputBar.h"
#import "HYChatInputView.h"

@interface HYLiveInputBar() <HYLiveInputViewDelegate>

/** 键盘的frame */
@property (nonatomic,assign) CGRect keyboardFrame;
/** 初始的frame */
@property (nonatomic,assign) CGRect originFrame;
/** 当前的frame */
@property (nonatomic,assign) CGRect currentFrame;
/** inputView */
@property (nonatomic,strong) HYChatInputView *inputTextView;

@end

@implementation HYLiveInputBar


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.inputTextView];
        [self registerKeyBoardNotifition];
        self.originFrame = frame;
    }
    return self;
}

- (void)dealloc{
    
    [self removeKeyboardNotification];
}

#pragma mark - registerNotification
- (void)registerKeyBoardNotifition{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillHideNotification:)
        name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - setter
- (void)setStatus:(HYLiveInputBarStatus)status{
    
    //如果不是输入文本，键盘消失
    if (status != HYLiveInputBarStatusInputText) {
        
        if (self.inputTextView.textField.isFirstResponder) {
            
            [self.inputTextView.textField resignFirstResponder];
        }
    }
    
    switch (status) {
        case HYLiveInputBarStatusDefault:
        {
            
            [self setFrame:self.originFrame];
        }
            break;
        case HYLiveInputBarStatusInputText:
        {
            [self.inputTextView.textField becomeFirstResponder];
        }
        default:
            break;
    }
}

- (void)clearInputContent{
    
    [self.inputTextView clearInputContent];
}

#pragma mark - sendMessageDelegate
- (void)sendButtonTaped:(NSString *)message{
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputBarSendMessage:)]) {
        
        [_delegate inputBarSendMessage:message];
    }
}

#pragma mark - notification callback
- (void)keyboardWillShowNotification:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = keyboardBounds.size.height;
    self.keyboardFrame = keyboardBounds;
    
    //改变inputBar的frame
    CGRect frame = self.frame;
    frame.origin.y = self.originFrame.origin.y - keyboardHeight;
    frame.size.height = keyboardHeight + 50;
    
    [UIView animateWithDuration:animationDuration animations:^{
       
        [UIView setAnimationCurve:animationCurve];
        [self setFrame:frame];
        [UIView commitAnimations];
    }];
    
    if (self.delegate && [_delegate respondsToSelector:@selector(inputBarContentSizeChanged:animationDuration:animationCurve:)]) {
        
        [_delegate inputBarContentSizeChanged:frame animationDuration:animationDuration animationCurve:animationCurve];
    }
    
    
    self.currentFrame = frame;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification{
    
   //将frame还原
    NSDictionary *userInfo = [notification userInfo];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_delegate && [_delegate respondsToSelector:@selector(inputBarContentSizeChanged:animationDuration:animationCurve:)]) {
        
        [_delegate inputBarContentSizeChanged:self.originFrame animationDuration:animationDuration animationCurve:animationCurve];
    }
    
    self.currentFrame = self.originFrame;
}

#pragma mark - lazyload
- (HYChatInputView *)inputTextView{
    
    if (!_inputTextView) {
        
        _inputTextView = [[HYChatInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _inputTextView.delegate = self;
    }
    return _inputTextView;
}

@end
