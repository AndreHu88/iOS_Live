//
//  HYImageTransition.h
//  live
//
//  Created by Jack on 2017/12/7.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYImageTransition : NSObject <UINavigationControllerDelegate>

/** 转场之前的frame */
@property (nonatomic,assign) CGRect beforeFrame;
/** 转场之后的frame */
@property (nonatomic,assign) CGRect afterFrame;
/** 转场的imgView */
@property (nonatomic,strong) UIImageView *transitionBeforeImgView;
/** 拖拽手势 */
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
/** 动画之前的截图 */
@property (nonatomic,strong) UIImage *screenShotImg;

@end
