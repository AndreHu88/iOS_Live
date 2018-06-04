//
//  HYBaseCellModel.h
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYBaseModel.h"

@interface HYBaseCellModel : HYBaseModel

@property(nonatomic,assign)  CGFloat cellHeight;
@property(nonatomic,copy)    NSString *cellIdientifier;
@property(nonatomic,weak)    id dataModel;
@property (nonatomic,copy)   NSString *title;

@end
