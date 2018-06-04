//
//  HYMusicPlayerDiscView.m
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicPlayerDiscView.h"
#import "HYDiscView.h"

@interface HYMusicPlayerDiscView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HYDiscView *leftDisc;
@property (nonatomic,strong) HYDiscView *rightDisc;
@property (nonatomic,strong) HYDiscView *centerDisc;
/** 播放指针 */
@property (nonatomic,strong) UIImageView *needleImgView;
@property (nonatomic,strong) UIView *discCycleBgView;
@property (nonatomic,assign) BOOL isAnimated;
@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation HYMusicPlayerDiscView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupInitViews];
        [self setScrollViewContentOffsetCenter];
        [self setupMasonryLayout];
    }
    return self;
}

- (void)setupInitViews{
    
    _discCycleBgView = [UIView new];
    _discCycleBgView.layer.borderWidth = 10;
    _discCycleBgView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    _discCycleBgView.clipsToBounds = YES;
    [self addSubview:_discCycleBgView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(KSCREEN_WIDTH * 3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _leftDisc = [[HYDiscView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _centerDisc = [[HYDiscView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH, 0, self.width, self.height)];
    _rightDisc = [[HYDiscView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH * 2, 0, self.width, self.height)];
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftDisc];
    [self.scrollView addSubview:self.centerDisc];
    [self.scrollView addSubview:self.rightDisc];
    
    _needleImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_needle_play"]];
    [self addSubview:self.needleImgView];
    
   
}

- (void)setupMasonryLayout{
    
    [_needleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self).offset(20);
        make.top.equalTo(self);
    }];
    
    [_discCycleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.width.mas_equalTo(_discCycleBgView.mas_height);
    }];
    
    [self layoutIfNeeded];
    _discCycleBgView.layer.cornerRadius = _discCycleBgView.width / 2;
}


- (void)setScrollViewContentOffsetCenter{
    
    [self.scrollView setContentOffset:CGPointMake(KSCREEN_WIDTH, 0)];
}

#pragma mark - setter
- (void)setMusicModel:(HYMusicModel *)musicModel{
    
    _musicModel = musicModel;
    self.centerDisc.imgFileName = musicModel.singerIcon;
    self.leftDisc.imgFileName = [[HYMusicHandleTool shareInstance] previousMusicModel].singerIcon;
    self.rightDisc.imgFileName = [[HYMusicHandleTool shareInstance] nextMusicModel].singerIcon;
    
    [self playedWithAnimated:YES];
}

- (void)pauseMusicWithAnimated:(BOOL)animated{
    
    if (self.isAnimated) return;
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    self.isAnimated = YES;
    [self setAnchorPoint:CGPointMake(25.0 / 97, 25.0 / 153) forView:self.needleImgView];
    if (animated) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.needleImgView.transform = CGAffineTransformMakeRotation(- M_PI_2 / 3);
        }];
    }
    else{
        self.needleImgView.transform = CGAffineTransformMakeRotation(- M_PI_2 / 3);
    }
    
    [[HYMusicHandleTool shareInstance] pauseCurrentMusic];
}

// 播放音乐时，指针恢复，图片旋转
- (void)playedWithAnimated:(BOOL)animated {
    
//    if (self.isAnimated) return;
    self.isAnimated = NO;
    
    [[HYMusicHandleTool shareInstance] playCurrentMusic];
    // 加入到主循环中
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.needleImgView.transform = CGAffineTransformIdentity;
        }];
    }
    else {
        self.needleImgView.transform = CGAffineTransformIdentity;
    }
    
   
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view{
    
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX <= (KSCREEN_WIDTH * 0.5)) {
        
        
    }
    else if (offsetX >= (KSCREEN_WIDTH * 1.5)){
        
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self pauseMusicWithAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEnd:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        
        [HYMusicHandleTool shareInstance].currentIndex -= 1;
        [self setCurrentPlayNeedChange:YES];
    }
    else if (offsetX == KSCREEN_WIDTH * 2){
        
        [HYMusicHandleTool shareInstance].currentIndex += 1;
        [self setCurrentPlayNeedChange:YES];
    }
    else{
        
        [self setScrollViewContentOffsetCenter];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(discViewDidChangeModel:)]) {
        
        [self.delegate discViewDidChangeModel:[HYMusicHandleTool shareInstance].getCurrentMusicModel];
        [[HYMusicHandleTool shareInstance] playCurrentMusic];
    }
}

- (void)setCurrentPlayNeedChange:(BOOL)needChange{
    
    if (needChange) {
        
        self.centerDisc.musicInfoImgView.transform = CGAffineTransformIdentity;
         self.centerDisc.imgFileName = [[HYMusicHandleTool shareInstance] getCurrentMusicModel].singerIcon;
        //每次设置后将scrollView回到中间
        [self setScrollViewContentOffsetCenter];
        self.leftDisc.imgFileName = [[HYMusicHandleTool shareInstance] previousMusicModel].singerIcon;
        self.rightDisc.imgFileName = [[HYMusicHandleTool shareInstance] nextMusicModel].singerIcon;
        
    }
    else{
        
        self.leftDisc.imgFileName = [[HYMusicHandleTool shareInstance] previousMusicModel].singerIcon;
        self.rightDisc.imgFileName = [[HYMusicHandleTool shareInstance] nextMusicModel].singerIcon;
    }
}



#pragma mark - action
- (void)displaylinkAction:(id)sender{
    
     self.centerDisc.musicInfoImgView.transform = CGAffineTransformRotate(self.centerDisc.musicInfoImgView.transform, M_PI_4 / 100);
}

#pragma mark - lazyload
- (CADisplayLink *)displayLink{
    
    if(!_displayLink){
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylinkAction:)];
    }
    return _displayLink;
}

@end
