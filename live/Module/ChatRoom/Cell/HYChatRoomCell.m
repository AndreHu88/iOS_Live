//
//  HYChatRoomCell.m
//  live
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYChatRoomCell.h"
#import "HYLevelView.h"

@implementation HYChatRoomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = KAPP_Clear_COLOR;
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}

#pragma mark - setter
- (void)setModel:(HYLiveMessageModel *)model{
    
    _model = model;
    RCMessageContent *content = model.content;
    if ([content isMemberOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *message = (RCTextMessage *)content;
        NSString *name = @"";
        if (message.senderUserInfo) {
            
            name = [NSString stringWithFormat:@"%@:",message.senderUserInfo.name];
        }
        NSString *messageStr = [NSString stringWithFormat:@"%@%@",name,message.content];
        [self createUserMessage:messageStr withName:name];
        
    }
    else if ([content isMemberOfClass:[RCInformationNotificationMessage class]]){
        
        RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)content;
        
        NSString *messageStr = [NSString stringWithFormat:@"系统消息:%@",notificationMessage.message];
        
        [self createNotificationMessage:messageStr];
    }
}

#pragma mark - 富文本Label
//创建用户消息
- (void)createUserMessage:(NSString *)messageStr withName:(NSString *)name{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    CGFloat height = [@"系统" heightForFont:KFitBoldFont(16) width:40] - 4;
    UIImage *image = [UIImage imageNamed:@"fowller"];
    
    HYLevelView *levelView = [[HYLevelView alloc] initWithFrame:CGRectMake(0, 0, 30, height) andLevel:8];
    
    NSMutableAttributedString *attachTextView = [NSMutableAttributedString attachmentStringWithContent:levelView contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(30, height) alignToFont:KFitBoldFont(16) alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:attachTextView];
    
    [attributedString appendString:@" "];
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(image.size.width + 10, height) alignToFont:KFitBoldFont(16) alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:attachText];
    
    [attributedString appendString:@" "];
    [attributedString appendString:messageStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KCOLOR(@"A3E9FF") range:NSMakeRange(0, name.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KAPP_WHITE_COLOR range:NSMakeRange(name.length, attributedString.length - name.length)];
    [attributedString addAttribute:NSFontAttributeName value:KFitBoldFont(16) range:NSMakeRange(0, attributedString.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.width - 20, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    _messageLabel.textLayout = textLayout;
    
    //计算高度
//    CGFloat strHeight = [messageStr heightForFont:KFitFont(16) width:self.width - 20];
    _messageLabel.size = textLayout.textBoundingSize;
    self.model.cellHeight = _messageLabel.height + 6;
    _messageLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        DLog(@"%@",text);
    };
}

//通知消息
- (void)createNotificationMessage:(NSString *)messageStr{
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendString:messageStr];
    [attributedString addAttributes:@{NSFontAttributeName : KFitBoldFont(16),NSForegroundColorAttributeName : KAPP_THEME_COLOR} range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:KAPP_WHITE_COLOR range:[messageStr rangeOfString:@"系统消息:"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.width - 20, MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    _messageLabel.textLayout = textLayout;
    //计算高度
    //CGFloat strHeight = [messageStr heightForFont:KFitBoldFont(16) width:self.width - 10];
    self.messageLabel.size = textLayout.textBoundingSize;
    self.model.cellHeight = self.messageLabel.height + 6;
    
    
}


#pragma mark - lazyload
- (YYLabel *)messageLabel{
    
    if (!_messageLabel) {
        
        _messageLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, 3, self.width - 20, 0)];
        _messageLabel.textColor = KAPP_THEME_COLOR;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = KFitFont(16);
        _messageLabel.displaysAsynchronously = YES;
        _messageLabel.preferredMaxLayoutWidth = self.width - 10;
        _messageLabel.backgroundColor = KAPP_Clear_COLOR;
    }
    return _messageLabel;
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
