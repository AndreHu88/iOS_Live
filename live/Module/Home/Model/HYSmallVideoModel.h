//
//  HYSmallVideoModel.h
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSmallVideoContent : NSObject

@property (nonatomic,copy) NSString *cover_url;
@property (nonatomic,copy) NSString *gif_url;
@property (nonatomic,copy) NSString *mp4_url;
@property (nonatomic,copy) NSString *scale_url;

@end

@interface HYSmallVideoModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *ctime;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *feed_type;
@property (nonatomic,copy) NSString *likeCount;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *portrait;
@property (nonatomic,copy) NSString *desc;
/** 内容 */
@property (nonatomic,strong) HYSmallVideoContent *contentInfo;


@end



/**
 "color": "#FF515151",
 "content": "{\"cover_url\":\"http://media01.inke.com/cover/MTUxMjYxNDI4NjExMCMxNTQjY292ZXI=\",\"gif_url\":\"http://media01.inke.com/gif/MTUxMjYxNDI4NjExMSM0NzQjZ2lm\",\"mp4_url\":\"http://media02.inke.com/mp4/MTUxMjYxNDI4NjQ1OSM5OTUjbXA0.mp4\",\"scale_url\":\"http://img2.inke.cn/MTQ5NzU4NDUyNDkyOCMyNjgjanBn.jpg\"}",
 "ctime": "1512614292420",
 "desc": "",
 "duration": "10",
 "feedId": "9912544",
 "feed_type": "0",
 "likeCount": "35",
 "liveId": "",
 "location": "北京",
 "origin_uid": "",
 "rotate": "0",
 "source": 0,
 "title": "哈哈哈 可爱",
 "tokenId": "104",
 "topicId": "",
 "topicName": "",
 "type": "0",
 "uid": "498264877",
 "viewCount": "1033",
 "nickname": "龙舞天团～萌妞儿",
 "portrait": "http://img2.inke.cn/MTQ5NzY2NzU4MDY0MyM4NTAjanBn.jpg",
 "verified": 0,
 "gender": 0,
 "level": 6,
 "origin_nickname": ""
 */
