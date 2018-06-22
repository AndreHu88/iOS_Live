//
//  HYGiftAnimationView.h
//  live
//
//  Created by Duntech on 2018/6/22.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYGiftShowModel.h"
#import "HYGiftCountLabel.h"

@interface HYGiftAnimationView : UIView

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) HYGiftShowModel *giftModel;
@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UIImageView *giftImageView;
@property (nonatomic,strong) UILabel *senderNameLabel;
@property (nonatomic,strong) UILabel *giftLabel;
@property (nonatomic,strong) HYGiftCountLabel *giftCountLabel;

@property (nonatomic,assign) NSInteger giftCount;
@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) BOOL isFinished;


- (void)animationComplectionBlock:(void(^)(BOOL isFinished, NSInteger count))finishedBlock;
- (void)shakeGiftCountLabel;
- (void)hideAnimationView;

@end
