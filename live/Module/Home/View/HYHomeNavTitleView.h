//
//  HYHomeNavTitleView.h
//  live
//
//  Created by Jack on 2017/11/24.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleBtnSelect)(NSInteger index);

@interface HYHomeNavTitleView : UIView


@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,copy) TitleBtnSelect titleBtnSelectBlock;

@end
