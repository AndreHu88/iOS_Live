//
//  HYLiveInputBar.h
//  live
//
//  Created by Jack on 2017/12/1.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYChatInputView.h"

/*!
 输入工具栏的输入模式
 */
typedef NS_ENUM(NSInteger, HYLiveInputBarStatus) {
    /*!
     初始状态
     */
    HYLiveInputBarStatusDefault = 0,
    /*!
     文本输入状态
     */
    HYLiveInputBarStatusInputText,
    /*!
     表情输入模式
     */
    HYLiveInputBarStatusEmoji
};

@protocol HYLiveInputBarControlDelegate <NSObject>

/*!
    @brief                      输入框的frame发生改变
    @param frame                当前的frame
    @param animationDuration    动画时间
    @param animationCurve       动画方式
*/
- (void)inputBarContentSizeChanged:(CGRect)frame
                 animationDuration:(CGFloat)animationDuration
                    animationCurve:(UIViewAnimationCurve)animationCurve;

/** 发消息 */
- (void)inputBarSendMessage:(NSString *)message;


@end

@interface HYLiveInputBar : UIView

/** 输入模式 */
@property (nonatomic,assign) HYLiveInputBarStatus status;
/** delegate */
@property (nonatomic,weak) id<HYLiveInputBarControlDelegate> delegate;

/*!
 清除输入框的内容
*/
- (void)clearInputContent;

@end
