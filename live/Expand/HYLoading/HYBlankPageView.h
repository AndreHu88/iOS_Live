//
//  HYBlankPageView.h
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BlankPageType) {
    
    //将所有的空白的类型定义成枚举
    BlankPageTypeLive = 0,
    BlankPageTypeSmallVideo,
    BlankPageTypeNear,
};


@interface HYBlankPageView : UIView

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *tipLabel, *titleLabel;
@property (nonatomic,strong) UIButton *reloadButton, *actionButton;
@property (nonatomic,assign) BlankPageType blankPageType;
@property (nonatomic,copy)   void(^reloadButtonBlock)(id sender);
@property (nonatomic,copy)   void(^actionButtonBlock)(void);

- (void)configBlankPageWithType:(BlankPageType )type
                        hasData:(BOOL)hasData
                       hasError:(BOOL)hasError
                         offset:(CGFloat)offset
              reloadButtonBlock:(void(^)(id sender))block;

@end
