//
//  HYSmallVideoViewModel.h
//  live
//
//  Created by Jack on 2017/12/8.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSmallVideoViewModel : NSObject

/** 退出小视频 */
@property (nonatomic,strong) RACSubject *quitPlayerSubject;

@end
