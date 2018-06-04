//
//  HYMusicPlayerDiscView.h
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMusicModel.h"

@protocol HYMusicPlayerDiscViewDelegate <NSObject>

- (void)discViewWillChangeModel:(HYMusicModel *)musicModel;
- (void)discViewDidChangeModel:(HYMusicModel *)musicModel;

@end


@interface HYMusicPlayerDiscView : UIView

@property (nonatomic,strong) HYMusicModel *musicModel;
@property (nonatomic,assign) id<HYMusicPlayerDiscViewDelegate> delegate;

- (void)pauseMusicWithAnimated:(BOOL)animated;
- (void)playedWithAnimated:(BOOL)animated;

@end
