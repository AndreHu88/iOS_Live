//
//  HYLyricTableViewCell.m
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricTableViewCell.h"
#import "HYLyricLabel.h"

@interface HYLyricTableViewCell ()

@property (nonatomic,strong) HYLyricLabel *lyricLabel;

@end

@implementation HYLyricTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.lyricLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews{
    
    [_lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 80, 0, 80));
    }];
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    self.lyricLabel.progress = progress;
}

- (void)setLyricModel:(HYLrcModel *)lyricModel{
    
    _lyricModel = lyricModel;
    self.lyricLabel.text = lyricModel.lrcStr;
}

- (HYLyricLabel *)lyricLabel{
    
    if (!_lyricLabel) {
        
        _lyricLabel = [[HYLyricLabel alloc] init];
        _lyricLabel.textColor = [UIColor whiteColor];
        _lyricLabel.font = KFitFont(13);
        _lyricLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lyricLabel;
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
