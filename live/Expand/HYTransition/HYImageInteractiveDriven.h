//
//  HYImageInteractiveDriven.h
//  live
//
//  Created by Jack on 2017/12/8.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYImageInteractiveDriven : UIPercentDrivenInteractiveTransition

/** 动画之前的截图 */
@property (nonatomic,strong) UIImage *screenShotImg;
/** 转场之后的frame */
@property (nonatomic,assign) CGRect transitionBeforeFrame;
/** 转场之后的frame */
@property (nonatomic,assign) CGRect transitionAfterFrame;
/** 当前的ImgView */
@property (nonatomic,strong) UIImageView *currentImgView;

- (instancetype)initWithGesture:(UIPanGestureRecognizer *)gesture;

@end
