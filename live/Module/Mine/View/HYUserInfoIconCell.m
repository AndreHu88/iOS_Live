//
//  HYUserInfoIconCell.m
//  live
//
//  Created by Duntech on 2018/7/30.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYUserInfoIconCell.h"
#import "UITableViewCell+HYCommon.h"

@implementation HYUserInfoIconCellModel



@end

@interface HYUserInfoIconCell ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleL;

@end

@implementation HYUserInfoIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, 11, 22, 22)];
        [self.contentView addSubview:_iconView];
    }
    
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + kPaddingLeftWidth, 12, kScreenWidth / 2, 20)];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = KFitFont(15);
        _titleL.textColor = UIColorHex(222222);
        [self.contentView addSubview:_titleL];
    }
}

- (void)setTitle:(NSString *)title icon:(NSString *)iconName{
    
    _titleL.text = title;
    _iconView.image = [UIImage imageNamed:iconName];
}

#pragma mark - ConfigModel
- (void)configWithModel:(id)model{
    
    HYUserInfoIconCellModel *cellModel = (HYUserInfoIconCellModel *)model;
    [self setTitle:cellModel.title icon:cellModel.iconName];
}

+ (CGFloat)cellHeight{
    return KAdaptedWidth(44);
}

#pragma mark Tip
- (void)prepareForReuse{
    
    [super prepareForReuse];
    [self removeTip];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)addTipIcon{
    
    CGFloat pointX = kScreenWidth - 40;
    CGFloat pointY = [[self class] cellHeight] / 2 ;
    [self.contentView addBadgeTip:@"badge" withCenterPosition:CGPointMake(pointX, pointY)];
}

- (void)removeTip{
    [self.contentView removeBadgeTips];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
