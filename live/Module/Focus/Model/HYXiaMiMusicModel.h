//
//  HYXiaMiMusicModel.h
//  live
//
//  Created by 胡勇 on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYBaseModel.h"

@interface HYXiaMiMusicLyricInfo : HYBaseModel

@property (nonatomic,copy) NSString *lyricId;
@property (nonatomic,copy) NSString *lyricType;
@property (nonatomic,copy) NSString *lyricFile;
@property (nonatomic,copy) NSString *isOfficial;

@end

@interface HYXiaMiListenFiles : HYBaseModel

@property (nonatomic,copy) NSString *listenFile;
@property (nonatomic,copy) NSString *quality;
@property (nonatomic,copy) NSString *expire;
@property (nonatomic,copy) NSString *format;
@property (nonatomic,copy) NSString *playVolume;
@property (nonatomic,copy) NSString *fileSize;

@end

@interface HYXiaMiMusicModel : HYBaseModel

@property (nonatomic,copy) NSString *songName;
@property (nonatomic,copy) NSString *albumLogo;
@property (nonatomic,copy) NSString *artistName;
@property (nonatomic,copy) NSString *artistLogo;
@property (nonatomic,copy) NSString *artistId;
@property (nonatomic,copy) NSString *length;
@property (nonatomic,strong) HYXiaMiMusicLyricInfo *lyricInfo;
@property (nonatomic,strong) NSArray <HYXiaMiListenFiles *> *listenFiles;

@end
