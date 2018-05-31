//
//  HYMusicProgressSlider.m
//  live
//
//  Created by 胡勇 on 2018/5/31.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicProgressSlider.h"

@interface HYMusicProgressSlider ()

@property (nonatomic,strong) UIView *progressBgView;
@property (nonatomic,strong) UIView *sliderProgressView;
@property (nonatomic,strong) HYSliderButton *sliderBtn;

@end

@implementation HYMusicProgressSlider

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    [self addSubview:self.progressBgView];
    [self addSubview:self.sliderProgressView];
}

#pragma mark - action
- (void)sliderBtnTouchBegin:(id)sender{
    
    
}

- (void)sliderBtnTouchEnded:(id)sender{
    
    
}

- (void)sliderBtnDragMoving:(UIButton *)btn event:(UIEvent *)event{
    
    
}



#pragma mark - lazyload
- (UIView *)progressBgView{
    
    if (!_progressBgView) {
        
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = [UIColor grayColor];
    }
    return _progressBgView;
}

- (UIView *)sliderProgressView{
    
    if (!_sliderProgressView) {
        
        _sliderProgressView = [UIView new];
        _sliderProgressView.backgroundColor = KAPP_NETEASE_COLOR;
    }
    return _sliderProgressView;
}

- (HYSliderButton *)sliderBtn{
    
    if (!_sliderBtn) {
        
        _sliderBtn = [HYSliderButton new];
        [_sliderBtn setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateNormal];
        [_sliderBtn setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateSelected];
        [_sliderBtn setBackgroundImage:[UIImage imageNamed:@"cm2_fm_playbar_btn"] forState:UIControlStateSelected];

        [_sliderBtn setImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
        [_sliderBtn setImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];
        [_sliderBtn setImage:[UIImage imageNamed:@"cm2_fm_playbar_btn_dot"] forState:UIControlStateNormal];

        
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchCancel];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderBtn addTarget:self action:@selector(sliderBtnTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
        [_sliderBtn addTarget:self action:@selector(sliderBtnDragMoving:event:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _sliderBtn;
}

@end

@implementation HYSliderButton



@end
