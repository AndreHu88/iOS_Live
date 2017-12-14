//
//  UILabel+HYJustifyAlign.m
//  Agency
//
//  Created by Jack on 2017/11/16.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "UILabel+HYJustifyAlign.h"

@implementation UILabel (HYJustifyAlign)

- (void)LabelAlightLeftAndRightWithWidth:(CGFloat)labelWidth {
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.font} context:nil].size;
    
    CGFloat margin = (labelWidth - textSize.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //设置字间距
    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1 )];
    self.attributedText = attribute;
}

@end
