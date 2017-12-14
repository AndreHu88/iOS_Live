//
//  HYLiveControllerVC.m
//  live
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#import "HYLiveControllerVC.h"
#import "HYLiveTopView.h"
#import "HYLiveBottomView.h"
#import "HYRCIMChatRoomHelper.h"
#import "HYLiveMessageModel.h"
#import "HYChatRoomCell.h"
#import "HYChatRoomManager.h"
#import "HYLiveInputBar.h"

@interface HYLiveControllerVC () <RCConnectionStatusChangeDelegate,RCIMClientReceiveMessageDelegate,UIGestureRecognizerDelegate,HYLiveInputBarControlDelegate>


@property (nonatomic,strong) HYLiveTopView *topView;
@property (nonatomic,strong) HYLiveBottomView *bottomView;
@property (nonatomic,strong) HYLiveInputBar *inputBar;
/** 动画计时器 */
@property (nonatomic, strong) dispatch_source_t timer;
/** 聊天室 */
@property (nonatomic,strong) HYChatRoomManager *chatRoomManager;
/** 聊天列表 */
@property (nonatomic,strong) UITableView *chatTableView;
/** 聊天数据 */
@property (nonatomic,strong) NSMutableArray *chatDataList;
/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;
/** 聊天室ID */
@property (nonatomic,strong) NSString *targetID;

@end

@implementation HYLiveControllerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSubviews];
    [self bindViewModel];
    [self initChatRoom];
    [self setupChatRoom];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [HYRCIMChatRoomHelper quitChatRoomWithTargetID:@"ChatRoom01" resultBlock:^(BOOL isSuccess) {
        
        [[RCIMClient sharedRCIMClient] logout];
    }];
    
    
}

#pragma mark - 初始化
- (void)setupSubviews{
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)bindViewModel{
    
    self.targetID = @"ChatRoom01";
    [self.bottomView setWithViewModel:self.viewModel];
    [RACObserve(self.viewModel, isPlaying) subscribeNext:^(id x) {
       
        DLog(@"-----state:%ld",(long)self.viewModel.player.playbackState);
        if ([x boolValue]) {
            
            [self initTimer];
            [self initChatRoom];
        }
        else{
            
            [self removeHeartImgAnimation];
        }
    }];
    
    [RACObserve(self.viewModel,stream_url) subscribeNext:^(id x) {
       
    }];
    
    [self.viewModel.chatSubject subscribeNext:^(id x) {
       
        self.inputBar.hidden = NO;
        self.inputBar.status = HYLiveInputBarStatusInputText;
    }];
}

- (void)setupChatRoom{
    
    [self.view layoutIfNeeded];
    self.chatRoomManager = [[HYChatRoomManager alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT - 80 * WIDTH_MULTIPLE - 130 * WIDTH_MULTIPLE, KSCREEN_WIDTH - 90 * WIDTH_MULTIPLE, 130 * WIDTH_MULTIPLE)];
    self.chatTableView = self.chatRoomManager.tableView;
    self.chatTableView.bounces = NO;
    [self.view addSubview:self.chatTableView];
    self.chatRoomManager.datalist = self.chatDataList;
    
    //添加手势，防止手势冲突
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.delegate = self;
    self.chatTableView.userInteractionEnabled = YES;
    [self.chatTableView addGestureRecognizer:tap];
}

- (void)initChatRoom{
    
    [HYRCIMChatRoomHelper setupRCIMWithComplectionBlock:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            [HYRCIMChatRoomHelper joinChatRoomWithTargetID:self.viewModel.targetID resultBlock:^(BOOL isSuccess) {
                
                if (!isSuccess) {
                    
                    [JRToast showWithText:@"加入聊天室失败了"];
                    return ;
                }
                
                
                // 设置消息接收监听
                [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
                
                RCInformationNotificationMessage *tipsMessage = [[RCInformationNotificationMessage alloc] init];
                tipsMessage.message = [NSString stringWithFormat: @"我们提倡绿色直播，严禁出现违纪违法，涉嫌国家政治，色情，恐吓等等等行为"];
                [self sendMessage:tipsMessage pushContent:nil];
                
                RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc] init];
                joinChatroomMessage.message = [NSString stringWithFormat: @"欢迎%@来到直播间",[RCIMClient sharedRCIMClient].currentUserInfo.name];
                [self sendMessage:joinChatroomMessage pushContent:nil];
            }];
        }
    }];
}

- (void)quitChatRoom{
    
    [HYRCIMChatRoomHelper quitChatRoomWithTargetID:self.targetID resultBlock:^(BOOL isSuccess) {
        
    }];
}


//将心动画移除
- (void)removeHeartImgAnimation{
    
    for (UIView * view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
    
        }
    }
}

- (void)viewDidLayoutSubviews{
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(30 * WIDTH_MULTIPLE);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(60 * WIDTH_MULTIPLE);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view).offset(-20 * WIDTH_MULTIPLE);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40 * WIDTH_MULTIPLE);
    }];
}

#pragma mark - method
- (void)initTimer{
    
    //初始化心形动画
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        //动画
        [self showHeartAnimation];
    });
    dispatch_resume(self.timer);
}


- (void)showHeartAnimation{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH - 100 * WIDTH_MULTIPLE, _bottomView.top, 25 * 229 / 200, 25)];
     NSArray *imageArray = @[@"heart_1",@"heart_2",@"heart_3",@"heart_4",@"heart_5",@"heart_1"];
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % 6]];
    [self.view addSubview:imageView];
    imageView.tag = 999;
    
    imageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    
    //贝塞尔曲线计算动画路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:imageView.center];
    
    CGFloat randomNum = arc4random() % 2 == 1 ? 1 : -1;
    //随机结束点
    CGPoint randomEndPoint = CGPointMake(imageView.center.x + randomNum * (arc4random() % 10), 100 * WIDTH_MULTIPLE + (arc4random() % 300));
    
    CGFloat randomNum1 = randomNum * (arc4random() % 100);
    CGFloat randomNum2 = randomEndPoint.y + 80 + (arc4random() % 90);
    //随机控制点
    CGPoint randomControlPoint1 = CGPointMake(imageView.center.x + randomNum1, randomNum2 + randomNum * (arc4random() % 50));
    CGPoint randomControlPoint2 = CGPointMake(imageView.center.x - randomNum1,randomNum2 - randomNum * (arc4random() % 50));
    [bezierPath addCurveToPoint:randomEndPoint controlPoint1:randomControlPoint1 controlPoint2:randomControlPoint2];
    
    CGFloat duration = 4 + arc4random() % 2;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    positionAnimate.path = bezierPath.CGPath;
    
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnination"];
    [UIView animateWithDuration:duration animations:^{
        
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        
        [imageView removeFromSuperview];
    }];
}

#pragma mark - 聊天室消息
/**
 *  判断消息是否在tableView的底部
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    
    if (self.chatTableView.contentSize.height <= self.chatTableView.frame.size.height) {
        return YES;
    }
    
    if(self.chatTableView.contentOffset.y >= (self.chatTableView.contentSize.height - self.chatTableView.frame.size.height)) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 *  将消息加入本地数组
 */
- (void)appendAndDisplayMessage:(RCMessage *)message {
    
    if (!message) {
        return;
    }
    
    HYLiveMessageModel *model = [[HYLiveMessageModel alloc] initWithMessage:message];
    model.cellHeight = 22;
    if ([self appendMessageModel:model]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatDataList.count - 1 inSection:0];
            
            NSInteger rowCount = [self.chatTableView numberOfRowsInSection:0];
            if (rowCount != self.chatDataList.count - 1) {
                return;
            }
            
            [self.chatTableView insertRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            BOOL isAtBottom = [self isAtTheBottomOfTableView];
            if (!isAtBottom || self.isNeedScrollToButtom) {
                
                [self scrollToBottomAnimated:YES];
                self.isNeedScrollToButtom = NO;
            }
        });
        
        
    }
}

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 */
- (BOOL)appendMessageModel:(HYLiveMessageModel *)model {
    
    long messageID = model.messageId;
    for (HYLiveMessageModel *__item in self.chatDataList) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (messageID == -1) {
            break;
        }
        if (messageID == __item.messageId) {
            return NO;
        }
    }
    
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.chatDataList.count > 100) {
        //                NSRange range = NSMakeRange(0, 1);
        HYLiveMessageModel *message = self.chatDataList[0];
        [[RCIMClient sharedRCIMClient] deleteMessages:@[@(message.messageId)]];
        [self.chatDataList removeObjectAtIndex:0];
        [self.chatTableView reloadData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.chatDataList addObject:model];
    });
    
    return YES;
}

/**
 *  消息滚动到底部
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger rowCount = [self.chatTableView numberOfRowsInSection:0];
    if (rowCount == 0) {
        return;
    }
//    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        
//       [self.chatTableView scrollToRowAtIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        [self.chatTableView scrollToBottomAnimated:animated];
        
    });
    
   
}

#pragma mark - 融云聊天室
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    
    DLog(@"融云连接状态变化了%ld",status);
}

- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object{
    
    RCMessageContent *content = message.content;
    if ([content isMemberOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *textMessage = (RCTextMessage *)content;
        DLog(@"---message:%@",textMessage.content);
    }
    else if ([content isMemberOfClass:[RCInformationNotificationMessage class]]){
        
        RCInformationNotificationMessage *notificationMessage = (RCInformationNotificationMessage *)content;
        DLog(@"----notification:%@",notificationMessage.message);

    }
    [self appendAndDisplayMessage:message];
    
    if (nLeft == 0) {
        
        self.isNeedScrollToButtom = YES;
    }
    
}

/*!
 发送消息(除图片消息外的所有消息)
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    
    if (self.targetID == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [HYRCIMChatRoomHelper sendMessageWithTargetID:self.targetID content:messageContent pushContent:pushContent pushData:nil success:^(long messageId) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.inputBar clearInputContent];
        });
        RCMessage *message = [[RCMessage alloc] initWithType:ConversationType_CHATROOM targetId:self.viewModel.targetID direction:MessageDirection_SEND messageId:messageId content:messageContent];
        message.senderUserId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
        [self appendAndDisplayMessage:message];
        DLog(@"消息发送成功:%ld",messageId);

        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
        DLog(@"消息发送失败:error:%ld,messageID:%ld",nErrorCode,messageId);
    }];
    
}

#pragma mark - chatBarDelegate
- (void)inputBarContentSizeChanged:(CGRect)frame animationDuration:(CGFloat)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve{
    
    CGRect tableViewFrame = self.chatTableView.frame;
    tableViewFrame.origin.y = KSCREEN_HEIGHT - 210 * WIDTH_MULTIPLE - frame.size.height + 50;
    
    [UIView animateWithDuration:animationDuration animations:^{
       
        [UIView setAnimationCurve:animationCurve];
        [self.chatTableView setFrame:tableViewFrame];
        [UIView commitAnimations];
    } completion:^(BOOL finished) {
        
        [self.inputBar setFrame:frame];
    }];

}

- (void)inputBarSendMessage:(NSString *)message{
    
    RCTextMessage *messageContent = [RCTextMessage messageWithContent:message];
    [self sendMessage:messageContent pushContent:nil];
}

#pragma mark - gestureDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([gestureRecognizer.view isKindOfClass:[self.chatTableView class]] ){
        
        _viewModel.isScrollViewCanScroll = NO;
        return YES;
        
    }
    else{
        
        _viewModel.isScrollViewCanScroll = YES;
        return YES;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)ges{
    
    self.inputBar.status = HYLiveInputBarStatusDefault;
    self.inputBar.hidden = YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.inputBar.status = HYLiveInputBarStatusDefault;
    self.inputBar.hidden = YES;
}



#pragma mark - lazyload
- (HYLiveTopView *)topView{
    
    if (!_topView) {
        
        _topView = [HYLiveTopView new];
    }
    return _topView;
}

- (HYLiveBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [HYLiveBottomView new];
    }
    return _bottomView;
}

- (NSMutableArray *)chatDataList{
    
    if (!_chatDataList) {
        
        _chatDataList = [NSMutableArray array];
        
    }
    return _chatDataList;
}

- (HYLiveInputBar *)inputBar{
    
    if (!_inputBar) {
        
        HYLiveInputBar *inputBar = [[HYLiveInputBar alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT - 50 , KSCREEN_WIDTH, 50)];
        inputBar.delegate = self;
        inputBar.hidden = YES;
        inputBar.status = HYLiveInputBarStatusDefault;
        [self.view addSubview:inputBar];
        
        _inputBar = inputBar;
    }
    return _inputBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
