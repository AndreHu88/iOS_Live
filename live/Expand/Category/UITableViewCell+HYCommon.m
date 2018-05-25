//
//  UITableViewCell+HYCommon.m
//  live
//
//  Created by Duntech on 2018/5/25.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "UITableViewCell+HYCommon.h"


@implementation UITableViewCell (HYCommon)

- (void)customAccessoryType:(UITableViewCellAccessoryType)type{
    
    self.tintColor = [UIColor colorWithHexString:@"0x136BFB"];
    NSInteger accessoryTag = 1234;
    if (type == UITableViewCellAccessoryDisclosureIndicator) {
        if (self.accessoryView.tag != accessoryTag) {
            UIView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_arrow"] highlightedImage:[UIImage imageNamed:@"cell_arrow"]];
            accessoryView.tag = accessoryTag;
            self.accessoryView = accessoryView;
        }
        self.accessoryView.hidden = NO;
        [self customAccessoryType:type];
    }
    else{
        if (self.accessoryView.tag == accessoryTag) {
            self.accessoryView.hidden = YES;
        }
        [self customAccessoryType:type];
    }
}

+ (void)load{
    
    Swizzle([UITableViewCell class], @selector(setAccessoryType:), @selector(customAccessoryType:));
}

@end
