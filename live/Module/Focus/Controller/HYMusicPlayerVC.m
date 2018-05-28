//
//  HYMusicPlayerVC.m
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicPlayerVC.h"
#import "HYMusicHandleTool.h"

@interface HYMusicPlayerVC ()

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation HYMusicPlayerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSubViews];
    self.title = self.musicModel.name;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setupNav];
}

- (void)setupNav{
    
    // 设置初始导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0];
    // 设置导航栏按钮和标题颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarTitleColor:KAPP_WHITE_COLOR];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}


- (void)setupSubViews{
    
    [self.view addSubview:self.bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setter
- (void)setMusicModel:(HYMusicModel *)musicModel{
    
    _musicModel = musicModel;
    [[HYMusicHandleTool shareInstance] playMusicWithModel:musicModel];
}

#pragma mark - lazyload
- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        // 添加模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = _bgImageView.bounds;
        [_bgImageView addSubview:effectView];
    }
    return _bgImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
