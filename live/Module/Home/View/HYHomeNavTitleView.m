//
//  HYHomeNavTitleView.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYHomeNavTitleView.h"

@interface HYHomeNavTitleView()

@property (nonatomic,strong) UIView *line;

@end

@implementation HYHomeNavTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createTopButtons];
        [self addSubview:self.line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            make.bottom.equalTo(self);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(self.width / 3 - 20);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)createTopButtons{
    
    NSArray *array = @[@"小视频",@"热门",@"吃鸡"];
    CGFloat btnWidth = self.width / array.count;
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, self.height);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = KFitFont(16);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}


#pragma mark - action
- (void)buttonAction:(UIButton *)button{
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        
        make.bottom.equalTo(self);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(self.width / 3 - 20);
        make.centerX.equalTo(button);
    }];
    
    if (self.titleBtnSelectBlock) {
        
        self.titleBtnSelectBlock(button.tag - 100);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    
    _selectIndex = selectIndex;
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        UIButton *button = [self viewWithTag:selectIndex + 100];
        make.bottom.equalTo(self);
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(self.width / 3 - 20);
        make.centerX.equalTo(button);
    }];}

#pragma mark - lazyload
- (UIView *)line{
    
    if (!_line) {
        
        _line = [UIView new];
        _line.backgroundColor = KAPP_WHITE_COLOR;
    }
    return _line;
}

@end
