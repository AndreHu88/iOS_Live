//
//  HYHotLiveModel.h
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYHotLiveCreator : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *nick;
@property (nonatomic,copy) NSString *portrait;

@end

//标签
@interface HYLiveExtra : NSObject

@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSArray *label;

@end

@interface HYHotLiveModel : NSObject

@property (nonatomic,copy) NSString *stream_addr;
@property (nonatomic,copy) NSString *room_id;
@property (nonatomic,copy) NSString *online_users;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,strong) HYHotLiveCreator *creator;
@property (nonatomic,strong) HYLiveExtra *extra;

/** cell行高 */
@property (nonatomic,assign) CGFloat cellHeight;

@end
