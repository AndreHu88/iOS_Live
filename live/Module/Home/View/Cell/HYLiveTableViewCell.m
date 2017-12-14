//
//  HYLiveTableViewCell.m
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveTableViewCell.h"

@interface HYLiveTableViewCell()

@property (nonatomic,strong) UIImageView *headerImgView;
@property (nonatomic,strong) UILabel *nickNameLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *thumbnailImgView;
@property (nonatomic,strong) UILabel *onLineLabel;

@end

@implementation HYLiveTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    [self addSubview:self.headerImgView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.onLineLabel];
    [self addSubview:self.thumbnailImgView];
    [self addSubview:self.titleLabel];

}

- (void)layoutSubviews{
    
    [_headerImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.top.equalTo(self).offset(15 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(40 * WIDTH_MULTIPLE, 40 * WIDTH_MULTIPLE));
    }];
    
    [_nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headerImgView.mas_right).offset(10 * WIDTH_MULTIPLE);
        make.top.equalTo(_headerImgView).offset(-4 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(160 * WIDTH_MULTIPLE, 20 * WIDTH_MULTIPLE));
    }];
    
    [_thumbnailImgView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.top.equalTo(_headerImgView.mas_bottom).offset(10 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(KSCREEN_WIDTH, KSCREEN_WIDTH));
    }];
    
    [_onLineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-20 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(90 * WIDTH_MULTIPLE, 30 * WIDTH_MULTIPLE));
        make.top.equalTo(_nickNameLabel);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(10 * WIDTH_MULTIPLE);
        make.bottom.equalTo(_thumbnailImgView.mas_bottom).offset(-10 * WIDTH_MULTIPLE);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

#pragma mark - setter
- (void)setModel:(HYHotLiveModel *)model{
    
    _model = model;
    
    _nickNameLabel.text = model.creator.nick;
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait] placeholderImage:[UIImage imageNamed:@"default_room"]];
    [_thumbnailImgView sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait] placeholderImage:[UIImage imageNamed:@"default_room"]];
    _onLineLabel.text = [NSString stringWithFormat:@"%@在看",model.online_users];
    _titleLabel.text = model.name;
    
    for (UIView *view in self.subviews) {
        
        if (view.tag >= 900 && [view isKindOfClass:[UILabel class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    [self createLabels];
    
    model.cellHeight = _thumbnailImgView.bottom;
}

//创建标签
- (void)createLabels{
    
    [self layoutIfNeeded];
    CGFloat labelLeft = _nickNameLabel.left;
    if (self.model.extra.label.count) {
        
        for (NSInteger i = 0; i < self.model.extra.label.count; i++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.textColor = KAPP_THEME_COLOR;
            label.layer.borderColor = KAPP_THEME_COLOR.CGColor;
            label.layer.borderWidth = 1;
            label.layer.cornerRadius = 8 * WIDTH_MULTIPLE;
            label.font = KFitFont(10);
            label.textAlignment = NSTextAlignmentCenter;
            NSString *labelText = self.model.extra.label[i][@"tab_name"];
            label.text = labelText;
            label.tag = 900 + i;
            
            CGFloat labelWidth = [labelText widthForFont:label.font] + 20;
            [self addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(_headerImgView);
                make.height.mas_equalTo(16 * WIDTH_MULTIPLE);
                make.width.mas_equalTo(labelWidth);
                make.left.equalTo(self).offset(labelLeft);
            }];
            
            labelLeft = labelLeft + labelWidth + 8;
        }
    }
    else{
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = KAPP_THEME_COLOR;
        label.layer.borderColor = KAPP_THEME_COLOR.CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 8 * WIDTH_MULTIPLE;
        label.font = KFitFont(10);
        label.textAlignment = NSTextAlignmentCenter;
        NSString *labelText = @"火星";
        label.text = labelText;
        label.tag = 905;
        
        CGFloat labelWidth = [labelText widthForFont:label.font] + 20;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(_headerImgView);
            make.height.mas_equalTo(16 * WIDTH_MULTIPLE);
            make.width.mas_equalTo(labelWidth);
            make.left.equalTo(self).offset(labelLeft);
        }];
    }
    
}

#pragma mark - lazyload
- (UIImageView *)headerImgView{
    
    if (!_headerImgView) {
        
        _headerImgView = [UIImageView new];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgView.layer.cornerRadius = 20 * WIDTH_MULTIPLE;
        _headerImgView.image = [UIImage imageNamed:@"default_room"];
        _headerImgView.clipsToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nickNameLabel{
    
    if (!_nickNameLabel) {
        
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = KAPP_7b7b7b_COLOR;
        _nickNameLabel.font = KFitFont(15);
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLabel;
}

- (UILabel *)onLineLabel{
    
    if (!_onLineLabel) {
        
        _onLineLabel = [UILabel new];
        _onLineLabel.textColor = [UIColor orangeColor];
        _onLineLabel.font = KFitFont(15);
        _onLineLabel.textAlignment = NSTextAlignmentRight;
        _onLineLabel.numberOfLines = 0;
    }
    return _onLineLabel;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = KAPP_WHITE_COLOR;
        _titleLabel.font = KFitFont(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIImageView *)thumbnailImgView{
    
    if (!_thumbnailImgView) {
        
        _thumbnailImgView = [UIImageView new];
        _thumbnailImgView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbnailImgView.image = [UIImage imageNamed:@"default_room"];
    }
    return _thumbnailImgView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
