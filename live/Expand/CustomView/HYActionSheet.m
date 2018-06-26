//
//  HYActionSheet.m
//  HYActionSheet
//
//  Created by leimo on 2017/6/26.
//  Copyright © 2017年 huyong. All rights reserved.
//


//获取屏幕宽度
#define KSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "HYActionSheet.h"

@interface HYActionSheet ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,copy)   void(^clickBlock)(NSInteger buttonIndex);

@end

@implementation HYActionSheet

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray buttonClickBlock:(void (^)(NSInteger))clickBlock{
    
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tapGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionSheet)];
        [self addGestureRecognizer:tapGes];
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.clickBlock = clickBlock;
        [self setupButtonWithArray:titleArray];
    }
    return self;
}

- (void)setupButtonWithArray:(NSArray *)titleArray{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, 50 * titleArray.count + 55)];
    _bgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_bgView];
    
    
    [self createButtonWithTitle:@"取消" originY:_bgView.frame.size.height - 50 tag:100];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        //创建button
         [self createButtonWithTitle:titleArray[i] originY:50 * i tag:i + 10];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       
        CGRect frame = _bgView.frame;
        frame.origin.y = self.frame.size.height - _bgView.frame.size.height;
        _bgView.frame = frame;
    }];
    
}

- (void)createButtonWithTitle:(NSString *)title originY:(CGFloat)originY tag:(NSInteger)tag{
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, originY, KSCREEN_WIDTH, 49.5)];
    visualEffectView.effect = blurEffect;
    visualEffectView.alpha = 0.6;
    [_bgView addSubview:visualEffectView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, originY, KSCREEN_WIDTH, 49.5);
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    [_bgView addSubview:button];
    
}

- (void)buttonAction:(UIButton *)button{
    
    self.clickBlock(button.tag - 10);
    [self hideActionSheet];
}

- (void)hideActionSheet{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = _bgView.frame;
        frame.origin.y = self.frame.size.height;
        _bgView.frame = frame;
    } completion:^(BOOL finished) {
        
        [_bgView removeFromSuperview];
        _bgView = nil;
        [self removeFromSuperview];
    }];
      
}

@end
