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
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setupNav];
}

- (void)setupNav{
    
//    [super setupNav];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.backgroundColor = KAPP_Clear_COLOR;
//    self.navigationController.navigationBar.barTintColor = KAPP_Clear_COLOR;
    [self setNeedsNavigationBackground:0];
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // _UIBarBackground
    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];
    // UIImageView
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];
    if (self.navigationController.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    
    // 对导航栏下面那条线做处理
    self.navigationController.navigationBar.clipsToBounds = alpha == 0.0;
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
