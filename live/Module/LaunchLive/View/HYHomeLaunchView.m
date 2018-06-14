//
//  HYHomeLaunchView.m
//  live
//
//  Created by Jack on 2017/12/26.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYHomeLaunchView.h"
#import "HYButton.h"

@interface HYHomeLaunchView ()

/** 白色背景图 */
@property (nonatomic,strong) UIView *whiteBgView;
/** 开直播 */
@property (nonatomic,strong) HYButton *startLiveBtn;
/** 录视频 */
@property (nonatomic,strong) HYButton *recordVideoBtn;

@end

@implementation HYHomeLaunchView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.whiteBgView];
    [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.mas_equalTo(200 * WIDTH_MULTIPLE);
    }];
    
    [self addSubview:self.startLiveBtn];
    [self addSubview:self.recordVideoBtn];
    
    _startLiveBtn.frame = CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH / 2, KAdaptedWidth(80));
    _recordVideoBtn.frame = CGRectMake(KSCREEN_WIDTH / 2, KSCREEN_HEIGHT, KSCREEN_WIDTH / 2, KAdaptedWidth(80));
}

#pragma mark - public
- (void)showLaunchView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_whiteBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_bottom).offset(-200 * WIDTH_MULTIPLE);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
           
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            [self setNeedsUpdateConstraints];
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            float j = 0;
            for (NSInteger i = 0; i < self.subviews.count; i++) {
                
                UIView *button = self.subviews[i];
                if ([button isKindOfClass:[HYButton class]]) {
                    
                    HYButton *btn = (HYButton *)button;
                    [self showAnimation:btn WithDelay:j];
                    j += 0.2;
                }
            }
        }];
    });
}

- (void)showAnimation:(UIView *)view WithDelay:(CGFloat)delay{
    
    view.alpha = 0;
    [UIView animateWithDuration:0.2 delay:delay usingSpringWithDamping:0.7 initialSpringVelocity:80 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        view.centerY = _whiteBgView.centerY;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideAnimation:(UIView *)view withDeley:(CGFloat)delay{
    
    view.alpha = 1;
    [UIView animateWithDuration:0.2 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:80 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        view.top = KSCREEN_HEIGHT;
        view.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideLaunchView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        for (NSInteger i = 0; i < self.subviews.count; i++) {
            
            UIView *button = self.subviews[i];
            float j = 0;
            if ([button isKindOfClass:[HYButton class]]) {
                
                HYButton *btn = (HYButton *)button;
                [self hideAnimation:btn withDeley:j];
                j += 0.2;
            }
        }
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _whiteBgView.top = KSCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (touchPoint.y <= _whiteBgView.top) {
        
        [self hideLaunchView];
    }
}

- (void)buttonClick:(UIButton *)sender{
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.tag - 100);
    }
}

#pragma mark - lazyload
- (UIView *)whiteBgView{
    
    if (!_whiteBgView) {
        
        _whiteBgView = [UIView new];
        _whiteBgView.backgroundColor = KAPP_WHITE_COLOR;
    }
    return _whiteBgView;
}

- (HYButton *)startLiveBtn{
    
    if (!_startLiveBtn) {
        
        _startLiveBtn = [HYButton buttonWithType:UIButtonTypeCustom];
        [_startLiveBtn setImage:[UIImage imageNamed:@"home_video_icon"] forState:UIControlStateNormal];
        [_startLiveBtn setTitle:@"开直播" forState:UIControlStateNormal];
        [_startLiveBtn setTitleColor:KAPP_7b7b7b_COLOR forState:UIControlStateNormal];
        _startLiveBtn.titleLabel.font = KFitFont(15);
        [_startLiveBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _startLiveBtn.tag = 100;
    }
    return _startLiveBtn;
}

- (HYButton *)recordVideoBtn{
    
    if (!_recordVideoBtn) {
        
        _recordVideoBtn = [HYButton buttonWithType:UIButtonTypeCustom];
        [_recordVideoBtn setImage:[UIImage imageNamed:@"iksv_topic_camera_icon"] forState:UIControlStateNormal];
        [_recordVideoBtn setTitle:@"录视频" forState:UIControlStateNormal];
        [_recordVideoBtn setTitleColor:KAPP_7b7b7b_COLOR forState:UIControlStateNormal];
        _recordVideoBtn.titleLabel.font = KFitFont(15);
        [_recordVideoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _recordVideoBtn.tag = 101;
    }
    return _recordVideoBtn;
}

@end
