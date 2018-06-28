//
//  HYCrashHandle.m
//  live
//
//  Created by Duntech on 2018/6/27.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYCrashHandle.h"
#import <execinfo.h>

static HYCrashHandle *crashHandle;
const NSString *KCaughtExecptionUserInfo = @"KCaughtExecptionUserInfo";
const NSExceptionName KSignalExceptionName = @"kSignalExceptionName";
const NSString *KSignalNumber = @"signalNumber";


@implementation HYCrashHandle

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashHandle = [[self class] new];
    });
    return crashHandle;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashHandle = [[self class] allocWithZone:zone];
    });
    return crashHandle;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self setupCatchExecptionHandle];
    }
    return self;
}

- (void)setupCatchExecptionHandle{
    
    /**
        Crash分两种
        一种是由EXC_BAD_ACCESS引起的，原因是访问了不属于本进程的内存地址，有可能是访问已被释放的内存
        另一种是未被捕获的Objective-C异常（NSException），导致程序向自身发送了SIGABRT信号而崩溃
     */
    
    //捕获异常导致的崩溃
    NSSetUncaughtExceptionHandler(&handleException);
    
    //捕获非异常 信号导致的错误
    //调用abort函数生成的信号
    signal(SIGABRT, handleSignalException);
    //执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号
    signal(SIGILL, handleSignalException);
    //试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.
    signal(SIGSEGV, handleSignalException);
    //发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误
    signal(SIGFPE, handleSignalException);
    //非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)
    signal(SIGBUS, handleSignalException);
    //管道破裂。这个信号通常在进程间通信产生，比如采用FIFO(管道)通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止
    signal(SIGPIPE, handleSignalException);
  
}

+ (NSArray *)backTrace{
    
    void *callStack[128];
    int frames = backtrace(callStack, 128);
    char **strs = backtrace_symbols(callStack, frames);
    NSMutableArray *backTraces = [NSMutableArray arrayWithCapacity:frames];
    for (NSInteger i = 0; i < frames; i++) {
        [backTraces addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backTraces;
}

- (void)exceptionHandler:(NSException *)exception{
    
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFArrayRef allModesArray = CFRunLoopCopyAllModes(runloopRef);
    [JRToast showWithText:@"program caught exception" duration:2];
    //获取当前的runloopMode，手动运行一遍
    while (1) {
        
        for (NSString *mode in (__bridge NSArray *)allModesArray) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.0001, false);
        }
    }
   
    
    //发生崩溃后，以下方法不会执行
//    CFRelease(allModesArray);
//    NSSetUncaughtExceptionHandler(NULL);
//
//    signal(SIGABRT, SIG_DFL);
//    signal(SIGILL, SIG_DFL);
//    signal(SIGSEGV, SIG_DFL);
//    signal(SIGFPE, SIG_DFL);
//    signal(SIGBUS, SIG_DFL);
//    signal(SIGPIPE, SIG_DFL);
    
//    if ([[exception name] isEqualToString:KSignalExceptionName]) {
//
//        kill(getpid(), [[[exception userInfo] objectForKey:KSignalNumber] integerValue]);
//    }
//    else{
//        [exception raise];
//    }
}

void handleException(NSException *exception){
    
    //获取堆栈异常信息
    NSArray *callStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:callStack forKey:KCaughtExecptionUserInfo];
    
    NSException *customException = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    [[HYCrashHandle sharedInstance] performSelectorOnMainThread:@selector(exceptionHandler:) withObject:customException waitUntilDone:YES];
    
}

void handleSignalException(int signal){
    
    NSArray *callStack = [HYCrashHandle backTrace];
    NSLog(@"捕获到信号异常:%@",callStack);
    NSException *exception = [NSException exceptionWithName:KSignalExceptionName reason:[NSString stringWithFormat:@"signal %d was raised",signal] userInfo:@{KSignalNumber: @(signal)}];
    [[HYCrashHandle sharedInstance] performSelectorOnMainThread:@selector(exceptionHandler:) withObject:exception waitUntilDone:YES];
}

@end
