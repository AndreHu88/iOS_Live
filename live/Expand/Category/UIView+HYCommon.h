//
//  UIView+HYCommon.h
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBlankPageView.h"
#import "UIBadgeView.h"

@interface LoadingView : UIView

@property (assign, nonatomic, readonly) BOOL isLoading;
@property (nonatomic,strong) YYAnimatedImageView *loadingImageView;
- (void)startAnimating;
- (void)stopAnimating;

@end


typedef NS_ENUM(NSInteger, BadgePositionType) {
    
    BadgePositionTypeDefault = 0,
    BadgePositionTypeMiddle
};

@interface UIView (HYCommon)

@property (nonatomic,strong) HYBlankPageView *blankPageView;
@property (nonatomic,strong) LoadingView *loadingView;


- (void)removeViewWithTag:(NSInteger)tag;
//添加渐变颜色
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray;
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )aPoint endPoint:(CGPoint)endPoint;

//blankPage
- (void)configBlankPageWithType:(BlankPageType)type
                        hasData:(BOOL)hasData
                       hasError:(BOOL)hasError
                         offset:(CGFloat)offset
              reloadButtonBlock:(void(^)(id sender))block;


- (UIView *)blankPageContainer;
- (UIViewController *)ViewController;

//HUD
- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)showHUDWithIcon:(NSString *)iconName text:(NSString *)text;
- (void)hideHUD;

//loading
- (void)beginLoading;
- (void)endLoading;

//badgeView
- (void)addBadgeTip:(NSString *)badgeValue withCenterPosition:(CGPoint)center;
- (void)addBadgeTip:(NSString *)badgeValue;
- (void)addBadgePoint:(NSInteger)pointRadius withPosition:(BadgePositionType)type;
- (void)addBadgePoint:(NSInteger)pointRadius withPointPosition:(CGPoint)point;
- (void)removeBadgePoint;
- (void)removeBadgeTips;

@end


