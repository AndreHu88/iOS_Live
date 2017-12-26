//
//  HYNearLiveModel.h
//  live
//
//  Created by Jack on 2017/12/25.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYHotLiveModel.h"

@interface HYNearLiveModel : NSObject


@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *landscape;
@property (nonatomic,copy) NSString *group;
@property (nonatomic,copy) NSArray *like;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *live_type;
@property (nonatomic,copy) NSString *multi;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *optimal;
@property (nonatomic,copy) NSString *room_id;
@property (nonatomic,copy) NSString *stream_addr;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,strong) HYHotLiveCreator *creator;

@end
