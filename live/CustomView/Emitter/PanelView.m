//
//  PanelView.m
//  PanelDemo
//
//  Created by leimo on 2017/5/12.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#define KLineWidth          10
#define KDialCount          30
#define KPieceCount         5

#import "PanelView.h"

@interface PanelView()

/**刻度数组*/
@property (nonatomic,strong) NSArray *dialArray;

@property (nonatomic,assign) CGFloat radius;

@property (nonatomic,assign) CGPoint viewCenter;



@end

@implementation PanelView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addCircleLayer];
        _dialArray =  @[@"0", @"400", @"800", @"1200", @"1600", @"2000", @"2400"];
        
        [self addSubview:self.pointerImgView];

    }
    return self;
}

- (void)addCircleLayer{
    
    CGFloat startAngle = M_PI_2 + M_PI_4;
    CGFloat endAngle = M_PI * 2 + M_PI_4;
    _radius = (self.frame.size.width - KLineWidth) / 2;
    
    CAShapeLayer *containerLayer = [CAShapeLayer layer];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = KLineWidth;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.shadowColor = [UIColor yellowColor].CGColor; // 阴影颜色
    circleLayer.shadowOffset = CGSizeMake(1, 1); // 阴影偏移量
    circleLayer.shadowOpacity = 0.5; // 阴影透明度
    circleLayer.shadowRadius = 5;
    
    _viewCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_viewCenter radius:_radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    circleLayer.path = path.CGPath;
    [containerLayer addSublayer:circleLayer];
    
    for (NSInteger i = 0; i < KDialCount; i ++) {
        
        [self drawDialOnContainerLayer:containerLayer WithDialCount:i];
    }
    
    [self.layer addSublayer:containerLayer];

    
    // 渐变层
    CALayer *gradientLayer = [CALayer new];// 渐变层的组合
    // 生成左边渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    leftLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor];
    [gradientLayer addSublayer:leftLayer];
    
    // 生成右边渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
    [gradientLayer addSublayer:rightLayer];
    
    [gradientLayer setMask:containerLayer];
    [self.layer addSublayer:gradientLayer];
}

//画刻度
- (void)drawDialOnContainerLayer:(CALayer *)containerLayer WithDialCount:(NSInteger )index{

    //刻度层
    CAShapeLayer *dialItemLayer = [CAShapeLayer layer];
    dialItemLayer.lineCap = kCALineCapSquare;
    dialItemLayer.lineJoin = kCALineJoinRound;
    dialItemLayer.strokeColor = [UIColor greenColor].CGColor;
    dialItemLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //外点半径
    CGFloat outsideRadius = (self.frame.size.width - KLineWidth - KLineWidth) / 2;
    //内点半径
    CGFloat insideRadius = (outsideRadius - KLineWidth);

    _viewCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);

    if (index % KPieceCount == 0) {
        insideRadius -= 5;
    }
    
    CGFloat angle = M_PI_2 + M_PI_4 - index * (M_PI * 2 * 0.75 / KDialCount);
    CGPoint outsidePoint = CGPointMake(_viewCenter.x - outsideRadius * sin(angle), _viewCenter.y - outsideRadius * cos(angle));
    CGPoint insidePoint = CGPointMake(_viewCenter.x - insideRadius * sin(angle), _viewCenter.y - insideRadius * cos(angle));
    
    [path moveToPoint:insidePoint];
    [path addLineToPoint:outsidePoint];
    
    dialItemLayer.path = path.CGPath;
    [containerLayer addSublayer:dialItemLayer];
    
}

//绘制文字
- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.5);
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGFloat outsideRadius = _radius - KLineWidth / 2;
    CGFloat insideRadius = outsideRadius - KLineWidth;
    
    
    // 计算所得各个文字显示的位置相对于其insidePoint的偏移量,
    NSArray *xOffsetArr = @[@(15), @(7), @(5), @(-16), @(-40), @(-46), @(-30)];
    NSArray *yOffsetArr = @[@(-20), @(-10), @(0), @(5), @(0), @(-10), @(-20)];
    
    for (NSInteger i = 0; i < _dialArray.count; i ++) {
        
        CGFloat angle =  M_PI_2 + M_PI_4 - (M_PI * 2 *0.75 / 6) * i;
        CGPoint insidePoint = CGPointMake(_viewCenter.x - insideRadius * sin(angle), _viewCenter.y - insideRadius * cos(angle));
        CGFloat xOffset = [xOffsetArr[i] floatValue];
        CGFloat yOffset = [yOffsetArr[i] floatValue];
        CGRect rect = CGRectMake(insidePoint.x + xOffset, insidePoint.y + yOffset , 60, 20);
        NSString *text = _dialArray[i];
        [text drawInRect:rect withAttributes:attributes];
        
    }
    
}

- (UIImageView *)pointerImgView{

    if (!_pointerImgView) {
        
        _pointerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewCenter.x - 10, _viewCenter.y, 20, self.frame.size.width / 2 - 60)];
        _pointerImgView.image = [UIImage imageNamed:@"pointerV2.png"];
        _pointerImgView.contentMode = UIViewContentModeScaleAspectFit;
        _pointerImgView.layer.anchorPoint = CGPointMake(0.5f, 0.9f); // 锚点
        _pointerImgView.layer.position = CGPointMake(_viewCenter.x, _viewCenter.y);
        _pointerImgView.transform = CGAffineTransformMakeRotation(-(M_PI/2 + M_PI_4));
        
    }
    return _pointerImgView;
}

@end
