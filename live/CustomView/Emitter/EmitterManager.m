//
//  EmitterManager.m
//  CAEmitter
//
//  Created by leimo on 2017/5/31.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "EmitterManager.h"
#import <UIKit/UIKit.h>

#define EmitterColor_Red      [UIColor colorWithRed:255/255.0 green:0 blue:139/255.0 alpha:1]
#define EmitterColor_Yellow   [UIColor colorWithRed:251/255.0 green:197/255.0 blue:13/255.0 alpha:1]
#define EmitterColor_Blue     [UIColor colorWithRed:50/255.0 green:170/255.0 blue:207/255.0 alpha:1]

@implementation EmitterManager

+ (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [window addSubview:backgroundView];
    
    CAEmitterLayer *emitterLayer = createEmitterLayer(backgroundView);
    startAnimation(emitterLayer);
    
    CGFloat delayInSeconds = 5.0;
    dispatch_time_t delayTimer = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayTimer, dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.4 animations:^{
           
            [backgroundView removeFromSuperview];
        }];
    });
    
}

CAEmitterCell *subCell(UIImage *image){

    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.name = @"heart";
    cell.contents = (__bridge id)image.CGImage;
    
//    cell.scale = 0.6;                       //缩放比例
//    cell.scaleRange = 0.6;
//    cell.scaleSpeed = -0.05;
//    
//    cell.lifetime = 20;                     //粒子存活时间
//    cell.velocity = 100.f;                   //粒子运动的速度均值
//    cell.velocityRange = 200.f;              //粒子运动的速度扰动范围
//    cell.alphaSpeed = -0.3;                 //粒子消逝的速度
//    cell.emissionRange = M_PI;              //粒子的发射角度
//    
//    cell.yAcceleration = 9.8;               //粒子的初始加速度
//    cell.xAcceleration = 0;
//    
//    //cell.birthRate = 20;                    //每秒产生的数量
//    cell.spin = M_PI * 2;                   //旋转
//    cell.spinRange = M_PI * 2;              //旋转的偏移量
//    cell.alphaRange = 0.3;                  //变色速率
    
    // 缩放比例
    cell.scale      = 0.6;
    cell.scaleRange = 0.6;
    // 每秒产生的数量
    //    cell.birthRate  = 40;
    cell.lifetime   = 20;
    // 每秒变透明的速度
    //    snowCell.alphaSpeed = -0.7;
    //    snowCell.redSpeed = 0.1;
    // 秒速
    cell.velocity      = 200;
    cell.velocityRange = 200;
    cell.yAcceleration = 9.8;
    cell.xAcceleration = 0;
    //掉落的角度范围
    cell.emissionRange  = M_PI;
    
    cell.scaleSpeed		= -0.05;
    ////    cell.alphaSpeed		= -0.3;
    cell.spin			= 2 * M_PI;
    cell.spinRange		= 2 * M_PI;

    return cell;
}

UIImage *imageWitchColor(UIColor *color){

    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

CAEmitterLayer *createEmitterLayer(UIView *view){
    
    //创建色块粒子
    CAEmitterCell *subCell1 = subCell(imageWitchColor(EmitterColor_Red));
    subCell1.name = @"red";
    
    CAEmitterCell *subCell2 = subCell(imageWitchColor(EmitterColor_Blue));
    subCell2.name = @"blue";
    
    CAEmitterCell *subCell3 = subCell(imageWitchColor(EmitterColor_Yellow));
    subCell3.name = @"blue";
    
    CAEmitterCell *subCell4 = subCell([UIImage imageNamed:@"success_star"]);
    subCell4.name = @"star";
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = view.center;
    emitterLayer.emitterSize = CGSizeMake(270, 170);
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4];
    [view.layer addSublayer:emitterLayer];
    return emitterLayer;
}

void startAnimation(CAEmitterLayer *layer){
    
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue = [NSNumber numberWithFloat:30];
    redBurst.toValue = [NSNumber numberWithFloat:0];
    redBurst.duration = 0.5;
    redBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    blueBurst.fromValue = [NSNumber numberWithFloat:30];
    blueBurst.toValue = [NSNumber numberWithFloat:0];
    blueBurst.duration = 0.5;
    blueBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue = [NSNumber numberWithFloat:30];
    yellowBurst.toValue = [NSNumber numberWithFloat:0];
    yellowBurst.duration = 0.5;
    yellowBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.star.birthRate"];
    starBurst.fromValue = [NSNumber numberWithFloat:30];
    starBurst.toValue = [NSNumber numberWithFloat:0];
    starBurst.duration = 0.5;
    starBurst.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[redBurst,blueBurst,yellowBurst,starBurst];
    [layer addAnimation:group forKey:@"heartBurst"];
}

@end
