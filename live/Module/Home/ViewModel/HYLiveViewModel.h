//
//  HYLiveViewModel.h
//  live
//
//  Created by Jack on 2017/11/28.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYHotLiveModel.h"

@interface HYLiveViewModel : NSObject

/** 播放地址 */
@property (nonatomic,copy) NSString *stream_url;
/** 聊天室ID */
@property (nonatomic,copy) NSString *targetID;
/** 播放器 */
@property (nonatomic,strong) IJKFFMoviePlayerController * player;
/** 聊天室 */
@property (nonatomic,strong) RACSubject *chatSubject;
/** 关闭直播 */
@property (nonatomic,strong) RACSubject *closeLiveSubject;
/** 是否正在播放 */
@property (nonatomic,assign) BOOL isPlaying;


/** scrollView是否能滚动 */
@property (nonatomic,assign) BOOL isScrollViewCanScroll;

- (void)setWithViewModel:(HYHotLiveModel *)model;

@end
