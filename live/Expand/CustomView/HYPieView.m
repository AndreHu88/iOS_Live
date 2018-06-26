//
//  HYPieView.m
//  Token_iOS
//
//  Created by Duntech on 2018/6/25.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYPieView.h"

#define  KOffsetRadius      20

@interface HYPieLayer : CAShapeLayer

@property (nonatomic,assign) CGFloat startAngle;
@property (nonatomic,assign) CGFloat endAngle;
@property (nonatomic,assign) BOOL isSelect;

@end

@implementation HYPieLayer

@end

@interface HYPieView ()

@property (nonatomic,copy) NSArray<NSNumber *> *dataNumbersArray;
@property (nonatomic,copy) NSArray<UIColor *> *colorsArray;

@property (nonatomic,assign) NSInteger radius;
@property (nonatomic,assign) CGPoint drawCenter;
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@end

@implementation HYPieView

- (instancetype)initWithFrame:(CGRect)frame datasArray:(NSArray<NSNumber *> *)dataNumbers colors:(NSArray<UIColor *> *)colors{
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataNumbersArray = dataNumbers;
        self.colorsArray = colors;
        
        _radius = KAdaptedWidth(100);
        _drawCenter = self.center;
        [self _initMaskLayer];
        [self _drawPieChart];
        [self strokeAnimation];
        
    }
    return self;
}

- (void)_initMaskLayer{
    
    _maskLayer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:_drawCenter radius:_radius startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
    _maskLayer.lineWidth = _radius * 2;
    //设置填充颜色为透明，
    _maskLayer.fillColor = [UIColor clearColor].CGColor;
    //设置边框为不透明，通过边框的绘制来显示整个view
    _maskLayer.strokeColor = [UIColor greenColor].CGColor;
    _maskLayer.path = bezierPath.CGPath;
    _maskLayer.strokeEnd = 0;
    self.layer.mask = _maskLayer;
    
}

- (void)_drawPieChart{
    
    //计算出数据总和
    CGFloat totalNum = [[_dataNumbersArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat start = -M_PI_2, end = -M_PI_2;
    
    for (NSInteger i = 0; i < _dataNumbersArray.count; i++) {
        
        CGFloat currentCount = _dataNumbersArray[i].floatValue;
        //当前的比例
        CGFloat currentRatio = currentCount / totalNum;
        CGFloat currentAngle = currentRatio * M_PI * 2;
        
        HYPieLayer *layer = [HYPieLayer layer];
        layer.startAngle = start;
        end = start + currentAngle;
        layer.endAngle = end;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:_drawCenter];
        [bezierPath addArcWithCenter:_drawCenter radius:_radius startAngle:start endAngle:end clockwise:YES];
        [bezierPath closePath];
        layer.fillColor = _colorsArray.count > i ? _colorsArray[i].CGColor : [UIColor redColor].CGColor;
        layer.path = bezierPath.CGPath;
        [self.layer addSublayer:layer];
        start += currentAngle;
        
//        UIBezierPath *linePath = [UIBezierPath bezierPath];
//        CGFloat middleAngle = (layer.startAngle + layer.endAngle) / 2;
//        CGFloat newX = self.drawCenter.x + _radius * cos(middleAngle);
//        CGFloat newY = self.drawCenter.y + _radius * sin(middleAngle);
//        [linePath moveToPoint:CGPointMake(newX, newY)];
//
//        CGFloat x1 = newX + 20 * cos(middleAngle);
//        CGFloat y1= newY + 40 * sin(middleAngle);
//        [linePath addLineToPoint:CGPointMake(x1, y1)];
//        CGFloat x2 = x1 + 40 * ((middleAngle > -M_PI_2 && middleAngle < M_PI) ? 1 : -1);
//        [linePath addLineToPoint:CGPointMake(x2 , y1)];
//        [linePath stroke];
//        //线条拐角
//        linePath.lineCapStyle = kCGLineCapRound;
//        linePath.lineWidth = 1;
//        [linePath stroke];
//
//        CAShapeLayer *lineLayer = [CAShapeLayer layer];
//        lineLayer.path = linePath.CGPath;
//        lineLayer.strokeColor = [UIColor orangeColor].CGColor;
//        lineLayer.fillColor = [UIColor clearColor].CGColor;
//        [self.layer addSublayer:lineLayer];
    }
    
}

- (void)strokeAnimation{
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = 1.0f;
    basicAnimation.fromValue = @(0.f);
    basicAnimation.toValue = @(1.f);
    basicAnimation.autoreverses = NO;       //禁止还原
    basicAnimation.repeatCount = 1;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.fillMode = kCAFillModeForwards;  //让动画保持在最后状态
    [_maskLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    [self touchesLayerWithPoint:touchPoint];
}

- (void)touchesLayerWithPoint:(CGPoint)touchesPoint{
    
    for (CALayer *layer in self.layer.sublayers) {
        //如果是自定义的pie layer
        if ([layer isKindOfClass:[HYPieLayer class]]) {
            
           HYPieLayer *pieLayer = (HYPieLayer *)layer;
            //判断当前的point在path中
            if (CGPathContainsPoint(pieLayer.path, &CGAffineTransformIdentity, touchesPoint, false) && !pieLayer.isSelect) {
                
                pieLayer.isSelect = YES;
                //改变中心点
                CGPoint currentPoint = pieLayer.position;
                //计算当前的layer，中间角度
                CGFloat middleAngle = (pieLayer.startAngle + pieLayer.endAngle) / 2;
                CGFloat newX = currentPoint.x + KOffsetRadius * cos(middleAngle);
                CGFloat newY = currentPoint.y + KOffsetRadius * sin(middleAngle);
                CGPoint newCenterPoint = CGPointMake(newX, newY);
                pieLayer.position = newCenterPoint;
            }
            else{
                pieLayer.position = CGPointMake(0, 0);
                pieLayer.isSelect = NO;
            }
        }
    }
}


@end
