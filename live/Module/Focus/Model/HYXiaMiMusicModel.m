//
//  HYXiaMiMusicModel.m
//  live
//
//  Created by 胡勇 on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYXiaMiMusicModel.h"

@implementation HYXiaMiMusicModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"listenFiles" : [HYXiaMiListenFiles class]};
}


@end

@implementation HYXiaMiListenFiles

@end

@implementation HYXiaMiMusicLyricInfo

@end
