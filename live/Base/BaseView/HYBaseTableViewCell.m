//
//  HYBaseTableViewCell.m
//  Booking
//
//  Created by Duntech on 2018/4/19.
//  Copyright © 2018年 Duntech. All rights reserved.
//

#import "HYBaseTableViewCell.h"

@implementation HYBaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = KAPP_WHITE_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configWithModel:(id)model{
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
