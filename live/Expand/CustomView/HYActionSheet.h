//
//  HYActionSheet.h
//  HYActionSheet
//
//  Created by leimo on 2017/6/26.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYActionSheet : UIView

- (instancetype)initWithFrame:(CGRect)frame WithTitleArray:(NSArray *)titleArray buttonClickBlock:(void(^)(NSInteger buttonIndex))clickBlock;

- (void)hideActionSheet;


@end
