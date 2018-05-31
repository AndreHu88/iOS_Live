//
//  HYLyricView.m
//  live
//
//  Created by Duntech on 2018/5/29.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYLyricView.h"
#import "HYLyricTableViewCell.h"

@interface HYLyricView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *lyricTableView;
/** 歌词滑动时的时间线及时间 */
@property (nonatomic,strong) UIView *timeLineView;
@property (nonatomic,strong) UILabel *timeLabel;
/** 记录历史歌词所在的行*/
@property (nonatomic, assign) NSInteger oldScrollRow;

@end

@implementation HYLyricView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lyricTableView];
        self.backgroundColor = [UIColor clearColor];
        self.oldScrollRow = -1;
    }
    return self;
}

- (void)layoutSubviews{
    
    [_lyricTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(40, 0, 40, 0));
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

- (void)setLyricDataSource:(NSArray<HYLrcModel *> *)lyricDataSource{
    
    _lyricDataSource = lyricDataSource;
    [self.lyricTableView reloadData];
}

- (void)setScrollRow:(NSInteger)scrollRow{
    
    _scrollRow = scrollRow;
    if (scrollRow != self.oldScrollRow) {
        
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

#pragma mark - lazyload
- (UITableView *)lyricTableView{
    
    if (!_lyricTableView) {
        
        _lyricTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _lyricTableView.delegate = self;
        _lyricTableView.dataSource = self;
        _lyricTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _lyricTableView.backgroundColor = [UIColor clearColor];
    }
    return _lyricTableView;
}


@end
