//
//  HYBlankPageView.m
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYBlankPageView.h"

@interface HYBlankPageView ()

@property (nonatomic,strong) UIButton *bottomButton;

@end

@implementation HYBlankPageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configBlankPageWithType:(BlankPageType)type hasData:(BOOL)hasData hasError:(BOOL)hasError offset:(CGFloat)offset reloadButtonBlock:(void (^)(id))block{
    
    if (hasData){
        [self removeFromSuperview];
        return;
    }
    [self setupSubView];
    NSString *imageName, *titleStr, *tipsStr, *buttonTitle;
    if (hasError) {
        
        //加载失败
        imageName = @"default_network_emptys";
        tipsStr = @"哎呀，网络出了问题";
        buttonTitle = @"重新连接";
        _actionButton.hidden = YES;
    }
    else{
        _reloadButton.hidden = YES;
        switch (type) {
            case BlankPageTypeLive:
            {
                tipsStr = @"当前暂无直播哟";
            }
                break;
                
            default:
            {
                tipsStr = @"这里什么都没有";
            }
                break;
        }
    }
    imageName = imageName ?: @"default_network_emptys";
    _bottomButton = hasError ? _reloadButton : _actionButton;
    [_bottomButton setTitle:buttonTitle forState:UIControlStateNormal];
    _bottomButton.hidden = (buttonTitle.length <= 0);
    _iconImageView.image = [UIImage imageNamed:imageName];
    _tipLabel.text = tipsStr;
    _titleLabel.text = titleStr;
    _titleLabel.hidden = (titleStr.length <= 0);
    
    if (fabs(offset) > 0) {
        self.frame = CGRectMake(0, offset, self.width, self.height);
    }
    [self setupMasonryLayout];
    if (self.reloadButtonBlock) {
        self.reloadButtonBlock = block;
    }
}

- (void)setupSubView{
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.reloadButton];
    [self addSubview:self.actionButton];
}

- (void)setupMasonryLayout{
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(160, 160));
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).multipliedBy(0.3);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(30);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_titleLabel);
        if (_titleLabel.text.length > 0) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        }
        else{
            make.top.equalTo(self.iconImageView.mas_bottom);
        }
    }];
    
    [_bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(130, 44));
        make.top.equalTo(_tipLabel.mas_bottom).offset(30);
    }];
}

#pragma mark - action
- (void)reloadButtonClicked:(id)sender{
    
    self.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.reloadButtonBlock) {
            
            self.reloadButtonBlock(sender);
            [self removeFromSuperview];
        }
    });
}

-(void)actionButtonTap{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.actionButtonBlock) {
            
            self.actionButtonBlock();
        }
    });
}

#pragma mark - lazyload
- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x425063"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)tipLabel{
    
    if (!_titleLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor colorWithHexString:@"0x76808E"];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)actionButton{
    
    if (!_actionButton) {
       
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.backgroundColor = [UIColor colorWithHexString:@"0x425063"];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_actionButton addTarget:self action:@selector(actionButtonTap) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.layer.cornerRadius = 4;
        _actionButton.layer.masksToBounds = YES;
    }
    return _actionButton;
}

- (UIButton *)reloadButton{
    
    if (!_reloadButton) {
        
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.backgroundColor = [UIColor colorWithHexString:@"0x425063"];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.layer.cornerRadius = 4;
        _reloadButton.layer.masksToBounds = YES;
    }
    return _reloadButton;
}

@end
