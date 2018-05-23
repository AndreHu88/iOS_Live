//
//  HYNearCollectionViewCell.m
//  live
//
//  Created by Jack on 2017/12/26.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYNearCollectionViewCell.h"


@interface HYNearCollectionViewCell ()

@property (nonatomic,strong) UIImageView *thumbnailImgView;
@property (nonatomic,strong) HYLevelView *levelView;
@property (nonatomic,strong) UILabel *distanceLabel;

@end

@implementation HYNearCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KAPP_WHITE_COLOR;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.thumbnailImgView];
    [self addSubview:self.levelView];
    [self addSubview:self.distanceLabel];
}

- (void)layoutSubviews{
    
    [_thumbnailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(6 * WIDTH_MULTIPLE);
        make.height.mas_equalTo(self.width);
    }];
    
    [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_thumbnailImgView.mas_bottom).offset(10 * WIDTH_MULTIPLE);
        make.left.equalTo(_thumbnailImgView);
        make.height.mas_equalTo(15 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(33 * WIDTH_MULTIPLE);
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_levelView.mas_right).offset(10 * WIDTH_MULTIPLE);
        make.top.bottom.equalTo(_levelView);
        make.width.mas_equalTo(80 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - setter
- (void)setModel:(HYNearLiveModel *)model{
    
    _model = model;
    [_thumbnailImgView sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait] placeholderImage:[UIImage imageNamed:@"default_room"]];
    _levelView.level = model.creator.level;
    _distanceLabel.text = model.distance;
}

- (void)showAnimation{
    
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.5);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        
    }];
}

#pragma mark - lazyload
- (UIImageView *)thumbnailImgView{
    
    if (!_thumbnailImgView) {
        
        _thumbnailImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thumbnailImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnailImgView.clipsToBounds = YES;
        _thumbnailImgView.image = [UIImage imageNamed:@"iksv_hotVideoBack"];
        _thumbnailImgView.layer.cornerRadius = 4 * WIDTH_MULTIPLE;
    }
    return _thumbnailImgView;
}

- (HYLevelView *)levelView{
    
    if (!_levelView) {
        
        NSInteger randomNum = arc4random() % 30;
        _levelView = [[HYLevelView alloc] initWithFrame:CGRectZero andLevel:randomNum];
        
    }
    return _levelView;
}

- (UILabel *)distanceLabel{
    
    if (!_distanceLabel) {
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = KFitFont(12);
        _distanceLabel.textColor = KAPP_BLACK_COLOR;
        _distanceLabel.text = @"4km";
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.numberOfLines = 0;
    }
    return _distanceLabel;
}


@end
