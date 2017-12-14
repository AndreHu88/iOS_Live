//
//  HYLocationManager.m
//  inke
//
//  Created by navy on 16/11/4.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "HYLocationManager.h"

@interface HYLocationManager ()

@end

@implementation HYLocationManager

+ (HYLocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static HYLocationManager *locationMgr;
    dispatch_once(&onceToken, ^{
        
        locationMgr = [[HYLocationManager alloc] init];
        
    });
    return locationMgr;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100;
        [_locationManager startUpdatingLocation];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        if([CLLocationManager locationServicesEnabled]){
            
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

- (void)getLocationInfo:(locationBlock)block{
    
    self.block = block;
}

#pragma mark  --CLlocationDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *coordinate = [locations lastObject];
    self.lat = [NSString stringWithFormat:@"%@",@(coordinate.coordinate.latitude)];
    self.lon = [NSString stringWithFormat:@"%@",@(coordinate.coordinate.longitude)];
    
    if (self.block) {
        
        self.block(_lat, _lon);
    }
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    //根据经纬度反编译地址信息
    [geoCoder reverseGeocodeLocation:coordinate completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (placemarks.count > 0) {
            
//            placemark.addressDictionary
//            SubLocality = "松江区",
//            CountryCode = "CN",
//            Street = "9号线",
//            State = "上海市",
//            Name = "九亭(地铁站)",
//            Thoroughfare = "9号线",
//            FormattedAddressLines = 	(
//                                         "中国上海市松江区九亭镇9号线",
//                                         ),
//            Country = "中国",
//            City = "上海市",
            
            // 包含区，街道等信息的地标对象
            CLPlacemark *placemark = [placemarks firstObject];
            // 城市名称
            NSString *city = placemark.locality;
            // 街道名称
            NSString *street = placemark.thoroughfare;
            // 全称
            NSString *specificLocation = placemark.name;
            
            self.city = city;
            self.street = street;
            
            if (self.detailLoactionInfoBlock) {
                
                self.detailLoactionInfoBlock(city, street, specificLocation);
            }
        }
    }];
    
//    self.block(_lat,_lon);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"locationError:%@",error);
}

@end
