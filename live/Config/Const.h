//
//  Const.h
//  xtd
//
//  Created by huyong on 2017/10/10
//  Copyright © 2017年 huyong All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject

/** 用户信息模型 */
extern NSString * const KUserModelData;

/** 用户信息 */
extern NSString * const KUserInfo;

/** 用户手机号 */
extern NSString *const KUserPhone;

/** 用户密码 */
extern NSString *const KUserPassword;

/** 用户登录类型 */
extern NSString *const KUserLoginType;

/** 微信登录通知 */
extern NSString *const KWeChatLoginNotification;

/** 微信支付成功通知 */
extern NSString *const KWeChatPaySuccessNotification;

/** 客服电话 */
extern NSString *const KCustomerServicePhone;

/** 购物车发生变化 */
extern NSString * const KShoppingCartsChanged;

/** 购物车数量发生变化 */
extern NSString * const KShoppingCartsCountChanged;

/** 城市信息的plist */
extern NSString * const KAddressPlist;

/** 产品分类plist */
extern NSString * const KSortListPlist;

/** 首页数据模型 */
extern NSString * const KHomePageDataModel;

/** 添加购物车成功 */
extern NSString * const KAddShoppingCartsSuccess;

@end
