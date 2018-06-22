//
//  HYGiftAnimationView.m
//  live
//
//  Created by Duntech on 2018/6/22.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYGiftAnimationView.h"

@interface HYGiftAnimationView ()

@property (nonatomic,copy) void(^finishedBlock)(BOOL isFinish, NSInteger finishCount);

@end

@implementation HYGiftAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _bgImageView.frame = self.bounds;

    _headerImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    _headerImageView.layer.borderWidth = 1;
    _headerImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.height / 2;
    _headerImageView.layer.masksToBounds = YES;
    
    _senderNameLabel.frame = CGRectMake(_headerImageView.right + 10, 5, self.width - 60, 20);
    _giftLabel.frame = CGRectMake(_senderNameLabel.left, _senderNameLabel.bottom, _senderNameLabel.width, _senderNameLabel.height);
    _giftCountLabel.frame = CGRectMake(self.right + 5, -20, 50, 30);
}

- (void)animationComplectionBlock:(void (^)(BOOL, NSInteger))finishedBlock{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(20, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        [self shakeGiftCountLabel];
    }];
    self.finishedBlock = finishedBlock;
}

- (void)shakeGiftCountLabel{
    
    //取消移除动画
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideAnimationView) object:nil];
    [self performSelector:@selector(hideAnimationView) withObject:self afterDelay:3];
    self.giftCountLabel.text = [NSString stringWithFormat:@"X %ld",_giftCount];
    [self.giftCountLabel startAnimationWithDuration:0.5];
}

- (void)hideAnimationView{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, self.frame.origin.y - 30, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.finishedBlock) {
            self.finishedBlock(finished, _giftCount);
        }
        _isFinished = finished;
        [self reset];
        [self removeFromSuperview];
    }];
}

- (void)reset{
    
    self.frame = _originFrame;
    self.alpha = 1;
    self.giftCountLabel.text = @"";
    
}

- (void)setGiftModel:(HYGiftShowModel *)giftModel{
    
    _giftModel = giftModel;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftUserModel.headerUrl] placeholderImage:[UIImage imageNamed:@""]];
    _senderNameLabel.text = giftModel.giftUserModel.name;
    _giftLabel.text = [NSString stringWithFormat:@"送了:%@",giftModel.giftModel.name];
    
    _giftCount = giftModel.giftModel.count;
}

- (void)setupSubViews{
    
    _bgImageView = [UIImageView new];
    _bgImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    _headerImageView = [UIImageView new];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    
    _senderNameLabel = [UILabel new];
    _senderNameLabel.textColor = [UIColor whiteColor];
    _senderNameLabel.font = KAdaptedFontSize(14);
    
    _giftLabel = [UILabel new];
    _giftLabel.textColor = [UIColor whiteColor];
    _giftLabel.font = KAdaptedFontSize(13);
    
    _giftCountLabel = [HYGiftCountLabel new];
    _giftCountLabel.borderColor = [UIColor yellowColor];
    _giftCountLabel.textColor = [UIColor greenColor];
    
    [self addSubview:_bgImageView];
    [self addSubview:_headerImageView];
    [self addSubview:_senderNameLabel];
    [self addSubview:_giftLabel];
    [self addSubview:_giftCountLabel];
    
}


@end
