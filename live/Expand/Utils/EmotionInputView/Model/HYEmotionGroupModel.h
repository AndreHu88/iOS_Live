//
//  HYEmotionGroupModel.h
//  live
//
//  Created by Duntech on 2018/6/7.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYEmotionGroupModel;

typedef NS_ENUM(NSUInteger, HYEmotionType) {
    
    HYEmotionTypeImage = 0,
    HYEmotionTypeEmoji = 1,
};

@interface HYemotionModel : NSObject

@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) HYEmotionType type;
@property (nonatomic, weak)   HYEmotionGroupModel *group;

@end

@interface HYEmotionGroupModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *display_only;
@property (nonatomic,copy) NSString *group_name_cn;
@property (nonatomic,copy) NSString *group_name_en;
@property (nonatomic,copy) NSString *group_name_tw;
@property (nonatomic,copy) NSString *group_type;
@property (nonatomic,strong) NSArray <HYemotionModel *> *emotions;

@end
