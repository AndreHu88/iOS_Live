//
//  HYNetWorkStateManager.h
//  Agency
//
//  Created by 胡勇 on 2017/11/10.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,NetWorkState){
    
    NetWorkStateNone,
    NetWorkState2G,
    NetWorkState3G,
    NetWorkState4G,
    NetWorkStateWIFI
} ;

@interface HYNetWorkStateManager : NSObject

@end
