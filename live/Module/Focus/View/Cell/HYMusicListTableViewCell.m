//
//  HYMusicListTableViewCell.m
//  live
//
//  Created by 胡勇 on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicListTableViewCell.h"

@interface HYMusicListTableViewCell ()

@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UILabel *musicNameLabel;
@property (nonatomic,strong) UILabel *artistLabel;
@property (nonatomic,strong) UIView *line;

@end

@implementation HYMusicListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.musicNameLabel];
        [self.contentView addSubview:self.artistLabel];
        [self.contentView addSubview:self.line];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews{
    
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(50 * WIDTH_MULTIPLE);
    }];
    
    [_musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.indexLabel.mas_right);
        make.top.equalTo(self).offset(5 * WIDTH_MULTIPLE);
        make.height.mas_equalTo(20 * WIDTH_MULTIPLE);
    }];
    
    [_artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.musicNameLabel.mas_bottom);
        make.left.equalTo(self.musicNameLabel);
        make.bottom.equalTo(self).offset(-5 * WIDTH_MULTIPLE);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.artistLabel);
    }];
}

- (void)setMusicModel:(HYXiaMiMusicModel *)musicModel{
    
    _musicModel = musicModel;
    _musicNameLabel.text = musicModel.songName;
    _artistLabel.text = musicModel.artistName;
    _indexLabel.text = [NSString stringWithFormat:@"%ld",self.currentIndexPath.row + 1];
}

- (void)setLocalMusicModel:(HYMusicModel *)localMusicModel{
    
    _localMusicModel = localMusicModel;
    _musicNameLabel.text = localMusicModel.name;
    _artistLabel.text = localMusicModel.singer;
    _indexLabel.text = [NSString stringWithFormat:@"%ld",self.currentIndexPath.row + 1];
}

#pragma mark - lazyload
- (UILabel *)indexLabel{
    
    if (!_indexLabel) {
        
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = KAPP_272727_COLOR;
        _indexLabel.font = KFitFont(14);
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

- (UILabel *)musicNameLabel{
    
    if (!_musicNameLabel) {
        
        _musicNameLabel = [[UILabel alloc] init];
        _musicNameLabel.textColor = [UIColor blackColor];
        _musicNameLabel.font = KFitFont(14);
        _musicNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _musicNameLabel;
}

- (UILabel *)artistLabel{
    
    if (!_artistLabel) {
        
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.textColor = KAPP_b7b7b7_COLOR;
        _artistLabel.font = KFitFont(12);
        _artistLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _artistLabel;
}

- (UIView *)line{
    
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = KAPP_SEPERATOR_COLOR;
    }
    return _line;
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
