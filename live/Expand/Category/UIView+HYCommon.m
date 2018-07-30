//
//  UIView+HYCommon.m
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "UIView+HYCommon.h"

static char BlankPageViewKey, LoadingViewKey;

#define kTagBadgePointView  1001
#define kTagBadgeView  1000


@implementation UIView (HYCommon)

- (UIViewController *)ViewController{
    
    for (UIView *next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIView *)blankPageContainer{
    
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

- (void)removeViewWithTag:(NSInteger)tag{
    
    for (UIView *aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}

- (void)addGradientLayerWithColors:(NSArray *)cgColorArray{
    [self addGradientLayerWithColors:cgColorArray locations:nil startPoint:CGPointMake(0.0, 0.5) endPoint:CGPointMake(1.0, 0.5)];
}

- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    if (cgColorArray && [cgColorArray count] > 0) {
        layer.colors = cgColorArray;
    }
    else{
        return;
    }
    if (floatNumArray && [floatNumArray count] == [cgColorArray count]) {
        layer.locations = floatNumArray;
    }
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    [self.layer addSublayer:layer];
}

#pragma mark - BlankPage
- (void)setBlankPageView:(HYBlankPageView *)blankPageView{
    
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey, blankPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (HYBlankPageView *)blankPageView{
    
   return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPageWithType:(BlankPageType)type hasData:(BOOL)hasData hasError:(BOOL)hasError offset:(CGFloat)offset reloadButtonBlock:(void (^)(id))block{
    
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }
    else{
        if (!self.blankPageView) {
            self.blankPageView = [[HYBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer insertSubview:self.blankPageView atIndex:0];
        [self.blankPageView configBlankPageWithType:type hasData:hasData hasError:hasError offset:offset reloadButtonBlock:block];
    }
}

#pragma mark - loading
- (void)beginLoading{
    
    for (UIView *aView in [self.blankPageContainer subviews]) {
        if ([aView isKindOfClass:[LoadingView class]] && !aView.hidden) {
            return;
        }
    }
    
    if (!self.loadingView) { //初始化LoadingView
        self.loadingView = [[LoadingView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.self.edges.equalTo(self);
    }];
    [self.loadingView startAnimating];
}

- (void)endLoading{
    
    if (self.loadingView) {
        [self.loadingView stopAnimating];
    }
}

#pragma mark - loading
- (void)setLoadingView:(LoadingView *)loadingView{
    
    objc_setAssociatedObject(self, &LoadingViewKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LoadingView *)loadingView{
    
    return objc_getAssociatedObject(self, &LoadingViewKey);
}

#pragma mark - HUD
- (void)showHUD{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    HUD.bezelView.color = [UIColor blackColor];            //设置菊花背景颜色
    HUD.contentColor = [UIColor whiteColor];               //设置内容颜色
    [HUD showAnimated:YES];
}

- (void)showHUDWithText:(NSString *)text{
    
    if ([text isKindOfClass:[NSNull class]] || text.length == 0) return;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    HUD.label.text = text;
    HUD.contentColor = [UIColor whiteColor];
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}

- (void)showHUDWithIcon:(NSString *)iconName text:(NSString *)text{
    
    if (iconName.length == 0 || text.length ==0)  return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    UIImage *image = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)hideHUD{
    
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        YYImage *gifImage = [YYImage imageNamed:@"loading.gif"];
        _loadingImageView = [[YYAnimatedImageView alloc] initWithImage:gifImage];
        _loadingImageView.image = gifImage;
        [self addSubview:_loadingImageView];
        
        [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
    }
    return self;
}

- (void)startAnimating{
    
    self.hidden = NO;
    [_loadingImageView startAnimating];
}

- (void)stopAnimating{
    
    [_loadingImageView stopAnimating];
    self.hidden = YES;
}

#pragma mark - Badge
- (void)addBadgePoint:(NSInteger)pointRadius withPosition:(BadgePositionType)type {
    
    if(pointRadius < 1)  return;
    [self removeBadgePoint];
    
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = kTagBadgePointView;
    badgeView.layer.cornerRadius = pointRadius;
    badgeView.backgroundColor = [UIColor redColor];
    
    switch (type) {
            
        case BadgePositionTypeMiddle:
            badgeView.frame = CGRectMake(0, self.frame.size.height / 2 - pointRadius, 2 * pointRadius, 2 * pointRadius);
            break;
            
        default:
            badgeView.frame = CGRectMake(self.frame.size.width - 2 * pointRadius, 0, 2 * pointRadius, 2 * pointRadius);
            break;
    }
    
    [self addSubview:badgeView];
}

- (void)addBadgePoint:(NSInteger)pointRadius withPointPosition:(CGPoint)point {
    
    if(pointRadius < 1)
        return;
    
    [self removeBadgePoint];
    
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = kTagBadgePointView;
    badgeView.layer.cornerRadius = pointRadius;
    badgeView.backgroundColor = [UIColor colorWithHexString:@"0xFF0000"];
    badgeView.frame = CGRectMake(0, 0, 2 * pointRadius, 2 * pointRadius);
    badgeView.center = point;
    [self addSubview:badgeView];
}

- (void)removeBadgePoint {
    
    for (UIView *subView in self.subviews) {
        
        if(subView.tag == kTagBadgePointView)
            [subView removeFromSuperview];
    }
}

- (void)addBadgeTip:(NSString *)badgeValue withCenterPosition:(CGPoint)center{
    if (!badgeValue || !badgeValue.length) {
        [self removeBadgeTips];
    }else{
        UIView *badgeV = [self viewWithTag:kTagBadgeView];
        if (badgeV && [badgeV isKindOfClass:[UIBadgeView class]]) {
            [(UIBadgeView *)badgeV setBadgeValue:badgeValue];
            badgeV.hidden = NO;
        }else{
            badgeV = [UIBadgeView viewWithBadgeTip:badgeValue];
            badgeV.tag = kTagBadgeView;
            [self addSubview:badgeV];
        }
        [badgeV setCenter:center];
    }
}
- (void)addBadgeTip:(NSString *)badgeValue{
    if (!badgeValue || !badgeValue.length) {
        [self removeBadgeTips];
    }else{
        UIView *badgeV = [self viewWithTag:kTagBadgeView];
        if (badgeV && [badgeV isKindOfClass:[UIBadgeView class]]) {
            [(UIBadgeView *)badgeV setBadgeValue:badgeValue];
        }else{
            badgeV = [UIBadgeView viewWithBadgeTip:badgeValue];
            badgeV.tag = kTagBadgeView;
            [self addSubview:badgeV];
        }
        CGSize badgeSize = badgeV.frame.size;
        CGSize selfSize = self.frame.size;
        CGFloat offset = 2.0;
        [badgeV setCenter:CGPointMake(selfSize.width- (offset+badgeSize.width/2),
                                      (offset +badgeSize.height/2))];
    }
}
- (void)removeBadgeTips{
    NSArray *subViews =[self subviews];
    if (subViews && [subViews count] > 0) {
        for (UIView *aView in subViews) {
            if (aView.tag == kTagBadgeView && [aView isKindOfClass:[UIBadgeView class]]) {
                aView.hidden = YES;
            }
        }
    }
}
@end
