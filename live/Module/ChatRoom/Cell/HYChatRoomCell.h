//
//  HYChatRoomCell.h
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLiveMessageModel.h"

@interface HYChatRoomCell : UITableViewCell

/*!
 当前消息Cell的数据模型
 */
@property (nonatomic,strong) HYLiveMessageModel *model;

/** 文字 */
@property (nonatomic,strong) YYLabel *messageLabel;

@end
