//
//  HYChatInputView.h
//  live
//
//  Created by Jack on 2017/12/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYLiveInputViewDelegate <NSObject>

/** 点击发送按钮 */
- (void)sendButtonTaped:(NSString *)message;

@end

@interface HYChatInputView : UIView

/** 输入区 */
@property (nonatomic,strong) UITextField *textField;
/** delegate */
@property (nonatomic,weak) id<HYLiveInputViewDelegate>delegate;


/*!
 清除输入框的内容
 */
- (void)clearInputContent;

@end


