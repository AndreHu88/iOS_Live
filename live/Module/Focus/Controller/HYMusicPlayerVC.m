//
//  HYMusicPlayerVC.m
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicPlayerVC.h"

@interface HYMusicPlayerVC ()

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation HYMusicPlayerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [super setupNav];
    [self setupSubViews];
}

- (void)setupSubViews{
    
    [self.view addSubview:self.bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - lazyload
- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_back"]];
    }
    return _bgImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
