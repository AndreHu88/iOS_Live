//
//  UIView+HYCommon.m
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "UIView+HYCommon.h"

static char BlankPageViewKey, LoadingViewKey;

@implementation UIView (HYCommon)

- (UIViewController *)findViewController{
    
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

@end
