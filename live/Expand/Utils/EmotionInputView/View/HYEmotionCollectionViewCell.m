//
//  HYEmotionCollectionViewCell.m
//  live
//
//  Created by Duntech on 2018/6/14.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYEmotionCollectionViewCell.h"
#import "HYEmotionInputHelper.h"

@interface HYEmotionCollectionViewCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation HYEmotionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    return self;
}

- (void)setEmotionModel:(HYEmotionModel *)emotionModel{
    
    if (_emotionModel == emotionModel) return;
    _emotionModel = emotionModel;
    [self setupContent];
}

- (void)setIsDelete:(BOOL)isDelete{
    
    _isDelete = isDelete;
    [self setupContent];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
}

- (void)setupContent{
    
    _imageView.image = nil;
    if (_isDelete) {

        _imageView.image = [HYEmotionInputHelper emotionImageNamed:@"compose_emotion_delete_highlighted"];
    }
    else if(_emotionModel){
        
        if (_emotionModel.type == HYEmotionTypeEmoji) {
            
            NSNumber *num = [NSNumber numberWithString:_emotionModel.code];
            NSString *str = [NSString stringWithUTF32Char:num.unsignedIntValue];
            if (str) {
                UIImage *img = [UIImage imageWithEmoji:str size:_imageView.width];
                _imageView.image = img;
            }
        }
        else if (_emotionModel.type == HYEmotionTypeImage && _emotionModel.group.id){
            
            NSString *emotionBundlePath = [[HYEmotionInputHelper resourceBundle] pathForScaledResource:_emotionModel.png ofType:nil inDirectory:_emotionModel.group.id];
            if (!emotionBundlePath) {
                NSString *additionalPath = [[HYEmotionInputHelper resourceBundle].bundlePath stringByAppendingPathComponent:@"additional"];
                NSBundle *emotionBundle = [NSBundle bundleWithPath:additionalPath];
                emotionBundlePath = [emotionBundle pathForScaledResource:_emotionModel.png ofType:nil inDirectory:_emotionModel.group.id];
            }
            [_imageView setImageWithURL:[NSURL fileURLWithPath:emotionBundlePath] options:YYWebImageOptionIgnoreDiskCache];
            
        }
    }
    
}

@end
