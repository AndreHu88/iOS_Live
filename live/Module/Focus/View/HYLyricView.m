//
//  HYLyricView.m
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricView.h"
#import "HYLyricTableViewCell.h"

static CGFloat CellHeight = 40.0f;

@interface HYLyricView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *lyricTableView;
/** 歌词滑动时的时间线及时间 */
@property (nonatomic,strong) UIView *timeLineView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *playBtn;
/** 记录历史歌词所在的行*/
@property (nonatomic,assign) NSInteger oldScrollRow;
//是否正在拖动歌词
@property (nonatomic,assign) BOOL isScrolling;
@property (nonatomic,strong) HYLrcModel *currentScrollLrcModel;

@end

@implementation HYLyricView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lyricTableView];
        [self addSubview:self.timeLineView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.playBtn];
        self.backgroundColor = [UIColor clearColor];
        self.oldScrollRow = -1;
    }
    return self;
}

- (void)layoutSubviews{
    
    [_lyricTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(40, 0, 40, 0));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.lyricTableView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.lyricTableView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.right.equalTo(self.playBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.lyricTableView);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - TableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lyricDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYLyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYLyricTableViewCell"];
    if (!cell) {
        cell = [[HYLyricTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HYLyricTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lyricModel = self.lyricDataSource[indexPath.row];
    if (indexPath.row == self.scrollRow) {
        cell.progress = self.progress;
    }
    else{
        cell.progress = 0;
    }
    return cell;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //取消之前所有的延时操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.isScrolling = YES;
    [self showScrollTimeLabel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        //减速完成
        self.isScrolling = NO;
        [self performSelector:@selector(endScroll) afterDelay:2];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //减速停止 3s后隐藏时间线，重新滚动tableView
    [self performSelector:@selector(endScroll) afterDelay:3];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //不是人为拖拽的
    if (!self.isScrolling) return;
    CGFloat offsetY  = scrollView.contentOffset.y;
    //计算当前的index
    NSInteger index = offsetY / CellHeight;
    self.currentScrollLrcModel = self.lyricDataSource[index];
    self.timeLabel.text = [HYLyricTimeTool getFormatTimeWithInterval:self.currentScrollLrcModel.beginTime];
}

- (void)hideScrollTimeLabel{
    
    self.timeLineView.hidden = YES;
    self.timeLabel.hidden = YES;
    self.playBtn.hidden = YES;
}

- (void)showScrollTimeLabel{
    
    self.timeLineView.hidden = NO;
    self.timeLabel.hidden = NO;
    self.playBtn.hidden = NO;
}

- (void)endScroll{
    
    [self hideScrollTimeLabel];
    [self setScrollRow:self.oldScrollRow];
}

#pragma mark - setter
- (void)setLyricDataSource:(NSArray<HYLrcModel *> *)lyricDataSource{
    
    _lyricDataSource = lyricDataSource;
    [self.lyricTableView reloadData];
}

- (void)setScrollRow:(NSInteger)scrollRow{
    
    _scrollRow = scrollRow;
    if (scrollRow != self.oldScrollRow && !self.isScrolling) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollRow inSection:0];
        [self.lyricTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        self.oldScrollRow = scrollRow;
    }
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    //获取当前row的cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scrollRow inSection:0];
    HYLyricTableViewCell *cell = [self.lyricTableView cellForRowAtIndexPath:indexPath];
    cell.progress = progress;
}

#pragma mark - action
- (void)playScrollTime{
    
    if (self.scrollLyricBlock) {
        self.scrollLyricBlock(self.currentScrollLrcModel.beginTime);
    }
}

#pragma mark - lazyload
- (UITableView *)lyricTableView{
    
    if (!_lyricTableView) {
        
        _lyricTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _lyricTableView.delegate = self;
        _lyricTableView.dataSource = self;
        _lyricTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _lyricTableView.backgroundColor = [UIColor clearColor];
        _lyricTableView.rowHeight = CellHeight;
    }
    return _lyricTableView;
}

- (UIView *)timeLineView {
    if (!_timeLineView) {
        _timeLineView = [UIView new];
        _timeLineView.backgroundColor = [UIColor darkGrayColor];
        _timeLineView.hidden = YES;
    }
    return _timeLineView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel           = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font      = [UIFont systemFontOfSize:13.0];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden    = YES;
    }
    return _timeLabel;
}

- (UIButton *)playBtn{
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playScrollTime) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

@end
