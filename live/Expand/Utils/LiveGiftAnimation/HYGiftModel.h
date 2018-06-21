//
//  HYGiftModel.h
//  live
//
//  Created by Duntech on 2018/6/21.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYGiftModel : NSObject

@property(nonatomic, strong) NSString *type;    /**< 礼物类型 */
@property(nonatomic, strong) NSString *name;    /**< 礼物的名称*/
@property(nonatomic, strong) NSString *picUrl;  /**< 右侧礼物图片url */
@property(nonatomic, strong) NSString *desc;    /**< 描述 */

@end

@interface HYGiftUserModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * headerUrl;

@end
