//
//  HYSmallVideoCollectionCell.m
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYSmallVideoCollectionCell.h"

@interface HYSmallVideoCollectionCell()


/** 标题 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 图像 */
@property (nonatomic,strong) UIImageView *headerImgView;
/** 喜欢 */
@property (nonatomic,strong) UIImageView *likeImgView;
/** 喜欢人数 */
@property (nonatomic,strong) UILabel *likeNumLabel;

@end

@implementation HYSmallVideoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
 
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.coverImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.headerImgView];
    [self addSubview:self.likeImgView];
    [self addSubview:self.likeNumLabel];
    
    [_likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-12 * WIDTH_MULTIPLE);
        make.bottom.equalTo(self).offset(-10 * WIDTH_MULTIPLE);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
}

- (void)layoutSubviews{
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(6 * WIDTH_MULTIPLE);
        make.bottom.left.right.equalTo(self);
    }];
    
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.bottom.equalTo(self).offset(-10 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(20 * WIDTH_MULTIPLE, 20 * WIDTH_MULTIPLE));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headerImgView);
        make.bottom.equalTo(self).offset(-40 * WIDTH_MULTIPLE);
        make.right.equalTo(self);
        make.height.mas_equalTo(20 * WIDTH_MULTIPLE);
    }];
    
    
    [_likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_likeNumLabel.mas_left);
        make.top.bottom.equalTo(_headerImgView);
        make.width.mas_equalTo(15);
    }];
}

#pragma mark - setter
- (void)setModel:(HYSmallVideoModel *)model{
    
    _model = model;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.contentInfo.cover_url] placeholderImage:[UIImage imageNamed:@"iksv_hotVideoBack"]];
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"ig_home_header_placeholder"]];
    _titleLabel.text = model.title;
    _likeNumLabel.text = model.likeCount;
    
    CGFloat likeNumWidth = [model.likeCount widthForFont:KFitFont(13)] + 3;
    [_likeNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(likeNumWidth);
    }];
    
}

#pragma mark - lazyload
- (UIImageView *)coverImageView{
    
    if (!_coverImageView) {
        
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.image = [UIImage imageNamed:@"iksv_hotVideoBack"];
        _coverImageView.layer.cornerRadius = 4 * WIDTH_MULTIPLE;
    }
    return _coverImageView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = KFitFont(12);
        _titleLabel.textColor = KAPP_WHITE_COLOR;
        _titleLabel.text = @"愿你出走半生，归来仍是少年";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)likeImgView{
    
    if (!_likeImgView) {
        
        _likeImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _likeImgView.contentMode = UIViewContentModeCenter;
        _likeImgView.clipsToBounds = YES;
        _likeImgView.image = [UIImage imageNamed:@"like_count_icon"];
    }
    return _likeImgView;
}

- (UIImageView *)headerImgView{
    
    if (!_headerImgView) {
        
        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImgView.clipsToBounds = YES;
        _headerImgView.image = [UIImage imageNamed:@"ig_home_header_placeholder"];
        _headerImgView.layer.cornerRadius = 10 * WIDTH_MULTIPLE;
    }
    return _headerImgView;
}

- (UILabel *)likeNumLabel{
    
    if (!_likeNumLabel) {
        
        _likeNumLabel = [[UILabel alloc] init];
        _likeNumLabel.font = KFitFont(12);
        _likeNumLabel.textColor = KAPP_WHITE_COLOR;
        _likeNumLabel.text = @"0";
        _likeNumLabel.textAlignment = NSTextAlignmentRight;
        _likeNumLabel.numberOfLines = 0;
    }
    return _likeNumLabel;
}
@end
