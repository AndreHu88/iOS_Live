//
//  HYFansView.m
//  live
//
//  Created by Jack on 2017/12/12.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYFansView.h"

@interface HYFansView()

/** levelLabel */
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation HYFansView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 2;
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - lazyload
- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = KAPP_WHITE_COLOR;
        _titleLabel.font = KFitFont(9);
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

@end
