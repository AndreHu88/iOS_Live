//
//  HYLrcModel.h
//  live
//
//  Created by Duntech on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLrcModel : NSObject

/** 开始时间*/
@property (nonatomic, assign) NSTimeInterval beginTime;

/** 结束时间*/
@property (nonatomic, assign) NSTimeInterval endTime;

/** 歌词*/
@property (nonatomic, copy) NSString *lrcStr;

@end
