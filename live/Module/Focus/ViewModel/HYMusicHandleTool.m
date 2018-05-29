//
//  HYMusicHandleTool.m
//  live
//
//  Created by Duntech on 2018/5/23.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYMusicHandleTool.h"
#import "HYMusicTool.h"

@interface HYMusicHandleTool ()

@property (nonatomic,strong) HYMusicTool *musicTool;
@property (nonatomic,assign) NSInteger currentLrcRow;
@property (nonatomic,strong) HYMusicModel *currentMusicModel;


@end

@implementation HYMusicHandleTool

#pragma mark - Instance
static HYMusicHandleTool *tool;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [[HYMusicHandleTool alloc] init];
    });
    return tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool = [super allocWithZone:zone];
    });
    return tool;
}

#pragma mark - lifeCycle
- (instancetype)init{
    
    if (self = [super init]) {
        
        _musicTool = [[HYMusicTool alloc] init];
        _currentMusicModel = [HYMusicModel new];
        _currentLrcRow = -1;
    }
    return self;
}

#pragma mark - publicMethod
- (BOOL)playMusicWithModel:(HYMusicModel *)model{
    
    NSString *fileName = model.filename;
    BOOL isPlaySucceed = [self.musicTool playMusic:fileName];
    if (self.musicList.count < 1) {
        return NO;
    }
    self.currentIndex = [self.musicList indexOfObject:model];
    return isPlaySucceed;
}

- (void)playCurrentMusic{
    
    [self playMusicWithModel:self.musicList[self.currentIndex]];
}

- (void)pauseCurrentMusic{
    
    [self.musicTool pauseMusicModel:self.currentMusicModel];
}

- (HYMusicModel *)getCurrentMusicModel{
    
    return self.musicList[self.currentIndex];
}

- (HYMusicModel *)previousMusicModel{
    
    if (self.currentIndex <= 0) {
        
        return self.musicList.lastObject;
    }
    NSInteger previousIndex = _currentIndex - 1;
    return self.musicList[previousIndex];
    
}

- (HYMusicModel *)nextMusicModel{
    
    if (self.currentIndex >= self.musicList.count - 1) {
        
        return self.musicList.firstObject;
    }
    NSInteger nextIndex = _currentIndex + 1;
    return self.musicList[nextIndex];
}


#pragma mark - setter
- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    if (currentIndex < 0) {
        currentIndex = self.musicList.count - 1;
    }
    
    if (currentIndex > self.musicList.count - 1) {
        currentIndex = 0;
    }
    _currentIndex = currentIndex;
}

- (NSArray<HYMusicModel *> *)musicList{
    
    if (!_musicList) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"QQResources" ofType:@"bundle"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *arr = [NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:@"Musics.plist"]];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                
                HYMusicModel *model = [HYMusicModel modelWithDictionary:dict];
                [tempArray addObject:model];
            }
            _musicList = tempArray.mutableCopy;
        });
    }
    return _musicList;
}


@end
