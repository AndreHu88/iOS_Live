//
//  HYLabel.h
//  DaCongMing
//
//  Created by 胡勇 on 2017/10/19.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VerticalAlignment) {
    
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface HYLabel : UILabel

/** verticalAlignment */
@property (nonatomic,assign) VerticalAlignment verticalAlignment;

@end
