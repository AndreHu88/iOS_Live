//
//  HYMusicControlView.h
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYMusicControlView;

@protocol HYMusicControlViewDelegate <NSObject>

- (void)controlView:(HYMusicControlView *)controlView didClickPrevious:(UIButton *)previousMusicButton;
- (void)controlView:(HYMusicControlView *)controlView didClickNextButton:(UIButton *)NextMusicButton;


@end


@interface HYMusicControlView : UIView

@property (nonatomic, copy)     NSString *currentTime;
@property (nonatomic, copy)     NSString *totalTime;
@property (nonatomic, assign)   CGFloat value;
@property (nonatomic, assign)   BOOL isLove;
@property (nonatomic, strong)   UIView *topView;
@property (nonatomic, weak)     id <HYMusicControlViewDelegate> delegate;

- (void)setupPlayBtn;
- (void)setupPauseBtn;

@end
