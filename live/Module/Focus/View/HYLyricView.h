//
//  HYLyricView.h
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLrcModel.h"

@interface HYLyricView : UIView

/** 歌词数据源 */
@property (nonatomic,copy) NSArray<HYLrcModel *> *lyricDataSource;
/** 指定歌词滚动到某一行*/
@property (nonatomic, assign) NSInteger scrollRow;
/** 当前歌词的播放进度*/
@property (nonatomic, assign) CGFloat progress;
/** 滚动歌词block */
@property (nonatomic, copy)   void(^scrollLyricBlock)(CGFloat scrollTime);

@end
