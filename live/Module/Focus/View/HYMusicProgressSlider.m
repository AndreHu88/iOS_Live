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
        
        self.sliderValue = 0;
        [self setupSubViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)setupSubViews{
    
    [self addSubview:self.progressBgView];
    [self addSubview:self.sliderProgressView];
    [self addSubview:self.sliderBtn];
    //给sliderView添加一个点击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self addGestureRecognizer:tapGes];
    
    _progressBgView.frame = CGRectMake(0, 0, self.width, 2);
    _sliderProgressView.frame = CGRectMake(0, 0, 0, 2);
    _sliderBtn.frame = CGRectMake(0, 0, 15, 15);
}

- (void)layoutSubviews{
    
   

    _progressBgView.centerY = self.centerY;
    _sliderProgressView.centerY = self.centerY;
    _sliderBtn.centerY = self.centerY;
    
//    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(self);
//        make.height.mas_equalTo(2);
//        make.left.right.equalTo(self);
//    }];
//
//    [self.sliderProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self);
//        make.top.bottom.equalTo(self.progressBgView);
//        make.width.mas_equalTo(0);
//    }];
//
//    [self.sliderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.width * self.sliderValue);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(15 * WIDTH_MULTIPLE, 15 * WIDTH_MULTIPLE));
//    }];
//
//    [self layoutIfNeeded];
}

- (void)setSliderValue:(CGFloat)sliderValue{
    
    _sliderValue = sliderValue;
    
    CGFloat currentLeft = self.width * sliderValue;
    
    //更新sliderView的frame 滑块按钮的frame
    self.sliderProgressView.width = currentLeft;
    self.sliderBtn.left = currentLeft;
    
//    [_sliderProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(currentLeft);
//    }];
//
//    [_sliderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(currentLeft);
//    }];
    
    
}


#pragma mark - action
- (void)sliderBtnTouchBegin:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueTouchBegin:)]) {
        
        [self.delegate sliderValueTouchBegin:self.sliderValue];
    }
}

- (void)sliderBtnTouchEnded:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueTouchEnd:)]) {
        
        [self.delegate sliderValueTouchEnd:self.sliderValue];
    }
}

- (void)sliderBtnDragMoving:(UIButton *)btn event:(UIEvent *)event{
    
    CGPoint point = [event.allTouches.anyObject locationInView:self];
    CGFloat value = (point.x - btn.width / 2) / self.progressBgView.width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 : value;
    self.sliderValue = value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        
        [self.delegate sliderValueChanged:value];
    }
}

- (void)sliderTapped:(UITapGestureRecognizer *)tapGes{
    
    CGPoint tapPoint = [tapGes locationInView:self];
    //计算进度
    CGFloat value = (tapPoint.x - self.progressBgView.left) / self.progressBgView.width;
    value = value >= 1.0 ? 1.0 : value <= 0 ? 0 :value;
    self.sliderValue = value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueTapped:)]) {
        
        [self.delegate sliderValueTapped:value];
    }
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
