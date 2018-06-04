//
//  HYTableViewCellDataBinding.h
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HYTableViewCellDataBinding <NSObject>

- (void)configWithModel:(id)model;

@end
