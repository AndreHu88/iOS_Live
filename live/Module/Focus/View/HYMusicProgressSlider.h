//
//  HYMusicProgressSlider.h
//  live
//
//  Created by 胡勇 on 2018/5/31.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYMusicProgressSliderDelegate <NSObject>

- (void)sliderValueTouchBegin:(CGFloat)sliderValue;

- (void)sliderValueChanged:(CGFloat)sliderValue;

- (void)sliderValueTouchEnd:(CGFloat)sliderValue;

- (void)sliderValueTapped:(CGFloat)sliderValue;


@end

@interface HYMusicProgressSlider : UIView

@property (nonatomic,weak) id<HYMusicProgressSliderDelegate> delegate;
@property (nonatomic,assign) CGFloat sliderValue;

@end


@interface HYSliderButton : UIButton

@end
