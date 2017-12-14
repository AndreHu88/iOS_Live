//
//  HYLevelView.m
//  live
//
//  Created by Jack on 2017/12/11.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLevelView.h"

@interface HYLevelView()

/** icon */
@property (nonatomic,strong) UIImageView *imageView;
/** levelLabel */
@property (nonatomic,strong) UILabel *levelLabel;

@end

@implementation HYLevelView

- (instancetype)initWithFrame:(CGRect)frame andLevel:(NSInteger)level{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KAPP_THEME_COLOR;
        self.layer.cornerRadius = 2;
        
        [self addSubview:self.imageView];
        [self addSubview:self.levelLabel];
        self.levelLabel.text = @(level).description;
    }
    return self;
}

- (void)layoutSubviews{
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(4);
        make.bottom.equalTo(self).offset(-4);
        make.left.equalTo(self).offset(4 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(12 * WIDTH_MULTIPLE);
    }];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-4 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(12 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - lazyload
- (UIImageView *)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"sun"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)levelLabel{
    
    if(!_levelLabel){
        
        _levelLabel = [UILabel new];
        _levelLabel.textColor = KAPP_WHITE_COLOR;
        _levelLabel.font = KFitFont(9);
        _levelLabel.textAlignment = NSTextAlignmentRight;
    }
    return _levelLabel;
}

@end
