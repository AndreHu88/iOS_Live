//
//  HYLocationManager.h
//  inke
//
//  Created by huyong on 16/11/4.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^locationBlock)(NSString *lat,NSString *lot);

typedef void(^detailLocationInfo)(NSString *city,NSString *street,NSString *specificLocation);

@interface HYLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

/** 维度 */
@property (nonatomic,copy) NSString *lat;
/** 经度 */
@property (nonatomic,copy) NSString *lon;
/** 城市 */
@property (nonatomic,copy) NSString *city;
/** 街道 */
@property (nonatomic,copy) NSString *street;
/** 经纬度block */
@property (nonatomic,copy) locationBlock block;
/** 详细地址 */
@property (nonatomic,copy) detailLocationInfo detailLoactionInfoBlock;


+ (HYLocationManager *)sharedManager;

- (void)getLocationInfo:(locationBlock)block;


@end
