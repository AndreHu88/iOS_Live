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
        
        [self setupSubviews];
        self.levelLabel.text = @(level).description;
    }
    return self;
}

- (void)setupSubviews{
    
    NSArray *colorArray = @[@"FFA500",@"FF8C00",@"00FF00",@"FF69B4",@"9400D3",@"6495ED"];
    self.backgroundColor = KCOLOR([colorArray randomObject]);
    self.layer.cornerRadius = 2;
    
    [self addSubview:self.imageView];
    [self addSubview:self.levelLabel];
}

- (void)setLevel:(NSString *)level{
    
    _level = level;
    
    if ([level integerValue] >= 10 && [level integerValue] <= 99) {
        
        self.levelLabel.font = KFitBoldFont(9);
    }
    
    if ([level integerValue] >= 100) {
        
        self.levelLabel.font = KFitBoldFont(7);
    }
    self.levelLabel.text = level;
}

- (void)layoutSubviews{
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(3 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(12 * WIDTH_MULTIPLE);
    }];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(2 * WIDTH_MULTIPLE);
        make.bottom.equalTo(self).offset(-2 * WIDTH_MULTIPLE);
        make.right.equalTo(self).offset(-2 * WIDTH_MULTIPLE);
        make.left.equalTo(_imageView.mas_right).offset(3 * WIDTH_MULTIPLE);
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
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = KFitBoldFont(12);
    }
    return _levelLabel;
}

@end
