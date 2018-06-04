//
//  HYDiscView.m
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYDiscView.h"

@implementation HYDiscView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.discBgImageView];
        [self addSubview:self.musicInfoImgView];
        
        [self setupMasonryLayout];
    }
    return self;
}

- (void)setupMasonryLayout{
    
    [_discBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.left.equalTo(self).offset(45);
        make.right.equalTo(self).offset(-45);
        make.width.mas_equalTo(_discBgImageView.mas_height);
    }];
    
    [_musicInfoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.discBgImageView).insets(UIEdgeInsetsMake(40 * WIDTH_MULTIPLE, 40 * WIDTH_MULTIPLE, 40 * WIDTH_MULTIPLE, 40 * WIDTH_MULTIPLE));
    }];
    
    [self layoutIfNeeded];
    _musicInfoImgView.layer.cornerRadius = _musicInfoImgView.width / 2;
    _musicInfoImgView.clipsToBounds = YES;
}

- (void)setImgFileName:(NSString *)imgFileName{
    
    _imgFileName = imgFileName;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QQResources" ofType:@"bundle"];
    NSString *filePath = [[path stringByAppendingPathComponent:@"Images"] stringByAppendingPathComponent:imgFileName];
    _musicInfoImgView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (UIImageView *)discBgImageView{
    
    if (!_discBgImageView) {
        
        _discBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc"]];
        _discBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _discBgImageView.clipsToBounds = YES;
    }
    return _discBgImageView;
}

- (UIImageView *)musicInfoImgView{
    
    if (!_musicInfoImgView) {
        _musicInfoImgView = [UIImageView new];
    }
    return _musicInfoImgView;
}




@end
