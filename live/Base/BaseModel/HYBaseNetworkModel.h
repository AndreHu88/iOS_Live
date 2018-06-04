//
//  HYBaseNetworkModel.h
//  Booking
//
//  Created by Duntech on 2018/4/18.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseNetworkModel : NSObject

@property (nonatomic,strong) id result;
@property (nonatomic,copy)   NSString *message;
@property (nonatomic,copy)   NSString *status;

@end
