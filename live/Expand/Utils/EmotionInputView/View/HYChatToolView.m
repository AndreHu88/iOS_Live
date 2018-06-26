//
//  HYChatToolView.m
//  live
//
//  Created by Duntech on 2018/6/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYChatToolView.h"

#define  KToolBarHeight     46

@interface HYChatToolView ()

@property (nonatomic,strong) UIView *toolBarBgView;
@property (nonatomic,strong) NSMutableArray <UIButton *> *toolBtnsArray;
@property (nonatomic,strong) UIButton *toolBarImageBtn, *toolBarCameraBtn, *toolBarEmotionBtn, *toolBarExtraBtn;

@end

@implementation HYChatToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _toolBtnsArray = [NSMutableArray array];
        [self _initInputView];
    }
    return self;
}

- (void)_initInputView{
    
    _toolBarBgView = [UIView new];
    _toolBarBgView.backgroundColor = UIColorHex(F9F9F9);
    _toolBarBgView.frame = CGRectMake(0, 0, self.width, KToolBarHeight);
    [self addSubview:_toolBarBgView];
    
    _toolBarImageBtn = [self _createToolBarButtonWithImage:@"compose_toolbar_picture" highlighted:@"compose_toolbar_picture_highlighted"];
    _toolBarCameraBtn = [self _createToolBarButtonWithImage:@"compose_camera" highlighted:@"compose_camera"];
    _toolBarEmotionBtn = [self _createToolBarButtonWithImage:@"compose_emoticonbutton_background" highlighted:@"compose_emoticonbutton_background_highlighted"];
    _toolBarExtraBtn = [self _createToolBarButtonWithImage:@"message_add_background" highlighted:@"message_add_background_highlighted"];
    
    CGFloat buttonWidth = KSCREEN_WIDTH / _toolBtnsArray.count;
    [_toolBtnsArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.centerX = idx * buttonWidth / 2;
    }];
    
}

- (UIButton *)_createToolBarButtonWithImage:(NSString *)imageName highlighted:(NSString *)highlightedImageName{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(toolbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.size = CGSizeMake(46, 46);
    button.centerY = KToolBarHeight / 2;
    
    [_toolBarBgView addSubview:button];
    [_toolBtnsArray addObject:button];
    return button;
}

- (void)toolbarButtonClick:(UIButton *)sender{
    
    if (sender == _toolBarEmotionBtn) {
        
    }
}

@end
