//
//  HYMusicPlayerVC.m
//  live
//
//  Created by 胡勇 on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicPlayerVC.h"
#import "HYMusicHandleTool.h"
#import "HYMusicPlayerDiscView.h"

@interface HYMusicPlayerVC () <HYMusicPlayerDiscViewDelegate>

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) HYMusicPlayerDiscView *discView;
@property (nonatomic,strong) YYLabel *titleLabel;

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
    [self.view addSubview:self.discView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - setter
- (void)setMusicModel:(HYMusicModel *)musicModel{
    
    _musicModel = musicModel;
    [[HYMusicHandleTool shareInstance] playMusicWithModel:musicModel];
    self.discView.musicModel = musicModel;
    
    [self setTitleLabelWithModel:musicModel];
}

- (void)setTitleLabelWithModel:(HYMusicModel *)musicModel{
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@",musicModel.name,musicModel.singer];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : KAPP_WHITE_COLOR}];
    [attributeStr addAttributes:@{NSFontAttributeName : KFitFont(14)} range:NSMakeRange(0, musicModel.name.length)];
    [attributeStr addAttributes:@{NSFontAttributeName : KFitFont(12)} range:NSMakeRange(musicModel.name.length, musicModel.singer.length)];
    [attributeStr setAlignment:NSTextAlignmentCenter];
    
    YYTextHighlight *sinerText = [[YYTextHighlight alloc] init];
    [attributeStr setTextHighlight:sinerText range:NSMakeRange(musicModel.name.length, musicModel.singer.length)];
    sinerText.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    };
    self.titleLabel.attributedText = attributeStr;
    self.navigationItem.titleView = self.titleLabel;
}

#pragma mark - discViewDelegate
- (void)discViewWillChangeModel:(HYMusicModel *)musicModel{
    
    
}

- (void)discViewDidChangeModel:(HYMusicModel *)musicModel{
    
    [self setTitleLabelWithModel:musicModel];
}

#pragma mark - lazyload
- (UIImageView *)bgImageView{
    
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_fm_bg"]];
        // 添加模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = self.view.bounds;
        [_bgImageView addSubview:effectView];
    }
    return _bgImageView;
}

- (HYMusicPlayerDiscView *)discView{
    
    if (!_discView) {
        
        _discView = [[HYMusicPlayerDiscView alloc] initWithFrame:CGRectMake(0, KIs_iPhoneX ? 88 : 64, KSCREEN_WIDTH, KSCREEN_HEIGHT - 200)];
        _discView.delegate = self;
    }
    return _discView;
}

- (YYLabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _titleLabel.centerX = self.view.centerX;
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = KAPP_WHITE_COLOR;
    }
    return _titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
