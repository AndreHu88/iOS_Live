//
//  HYMusicPlayInfoModel.h
//  live
//
//  Created by Duntech on 2018/5/30.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HYMusicPlayInfoModel : NSObject

@property (nonatomic,strong) HYMusicModel *musicModel;
@property (nonatomic,assign) NSTimeInterval currentPlayTime;
@property (nonatomic,assign) NSTimeInterval totalTime;
@property (nonatomic,assign) BOOL isPlay;

@end
