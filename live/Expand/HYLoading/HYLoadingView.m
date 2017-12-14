//
//  HYLoadingView.m
//  LoadingDemo
//
//  Created by Jack on 2017/12/6.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLoadingView.h"

@interface HYLoadingView()

/** layer */
@property (nonatomic,strong) CAReplicatorLayer *contentLayer;
/** 小圆点 */
@property (nonatomic,strong) CALayer *dotLayer;
/** 竖线 */
@property (nonatomic,strong) CALayer *lineLayer;

@end

@implementation HYLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self.layer addSublayer:self.contentLayer];
    }
    return self;
}

- (void)showDotLoading{
    
    [self.contentLayer addSublayer:self.dotLayer];
    NSInteger count = 10;
    self.contentLayer.instanceCount = count;
    CGFloat angel = M_PI * 2 / count;
    self.contentLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    //创建动画
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnimation.fromValue = @1;
    transformAnimation.toValue = @0.1;
    transformAnimation.repeatCount = MAXFLOAT;
    transformAnimation.duration = 1.0;
    self.contentLayer.instanceDelay = 1.0 / count;
    [self.dotLayer addAnimation:transformAnimation forKey:@"dotAnimatin"];
}

- (void)showLineLoading{
    
    [self.contentLayer addSublayer:self.lineLayer];
    self.contentLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.contentLayer.instanceCount = 4;
    self.contentLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.toValue = @(30);
    positionAnimation.autoreverses = YES;
    positionAnimation.repeatCount = MAXFLOAT;
    positionAnimation.duration = 0.3;
    [self.lineLayer addAnimation:positionAnimation forKey:@"lineLoading"];
    self.contentLayer.instanceDelay = 0.3 / 4;
}

- (void)showCircleLoading{
    
    [self.contentLayer addSublayer:self.dotLayer];
    self.contentLayer.instanceCount = 100;
    
    CGFloat angel = M_PI * 2 / 100;
    self.contentLayer.instanceTransform = CATransform3DMakeRotation(angel, 0, 0, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1.0;
    animation.fromValue = @1;
    animation.toValue = @0.1;
    animation.repeatCount = MAXFLOAT;
    [self.dotLayer addAnimation:animation forKey:@"circleAnimation"];
    self.contentLayer.instanceDelay = 1.0 / 100;
    self.dotLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)showInkeLoading{
    
    self.contentLayer.backgroundColor = [UIColor clearColor].CGColor;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentLayer.bounds];
    imageView.image = [UIImage imageNamed:@"msg_recovery_circle"];
    [self.contentLayer addSublayer:imageView.layer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 0.8;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [imageView.layer addAnimation:animation forKey:@"inkeLoading"];
    
    UIImageView *inkeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    inkeImgView.center = self.center;
    inkeImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:inkeImgView];   //如果添加在layer上动画将不会执行
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 29; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_00%02lu", (unsigned long)i]];
        [idleImages addObject:image];
    }
    inkeImgView.animationImages = idleImages;
    inkeImgView.animationDuration = 1;
    inkeImgView.animationRepeatCount = 0;
    [inkeImgView startAnimating];
}

#pragma mark - lazyload
- (CAReplicatorLayer *)contentLayer{
    
    if (!_contentLayer) {
        
        _contentLayer = [CAReplicatorLayer layer];
        _contentLayer.bounds = CGRectMake(0, 0, 100, 100);
        _contentLayer.position = self.center;
        _contentLayer.cornerRadius = 10.0f;
        _contentLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    }
    return _contentLayer;
}

- (CALayer *)dotLayer{
    
    if (!_dotLayer) {
        
        _dotLayer = [CALayer layer];
        _dotLayer.bounds = CGRectMake(0, 0, 10, 10);
        _dotLayer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.6].CGColor;
        _dotLayer.cornerRadius = 5;
        _dotLayer.masksToBounds = YES;
        _dotLayer.position = CGPointMake(50, 10);
        
    }
    return _dotLayer;
}

- (CALayer *)lineLayer{
    
    if (!_lineLayer) {
        
        CGFloat lineWidth = 5;
        CGFloat lineHeight = 50;
        _lineLayer = [CALayer layer];
        _lineLayer.bounds = CGRectMake(0, 0, lineWidth, lineHeight);
        _lineLayer.backgroundColor = [UIColor colorWithRed:(42 / 255.0) green:(227 / 255.0) blue:(166 / 255.0) alpha:1].CGColor;
        //position相当于该layer在父层的位置
        _lineLayer.position = CGPointMake(20, 70);
        
    }
    return _lineLayer;
}

@end
