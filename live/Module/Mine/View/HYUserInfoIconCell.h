//
//  HYUserInfoIconCell.h
//  live
//
//  Created by Duntech on 2018/7/30.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYBaseTableViewCell.h"

@interface HYUserInfoIconCellModel : HYBaseCellModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *value;

@end

@interface HYUserInfoIconCell : HYBaseTableViewCell

- (void)setTitle:(NSString *)title icon:(NSString *)iconName;

@end
