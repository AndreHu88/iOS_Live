//
//  HYVideoHardEncodeVC.m
//  live
//
//  Created by Duntech on 2018/6/14.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "HYVideoHardEncodeVC.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface HYVideoHardEncodeVC () <AVCaptureVideoDataOutputSampleBufferDelegate>

/** 会话对象 */
@property (nonatomic,strong) AVCaptureSession *session;
/** previewLayer */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) int64_t frameID;

@end

@implementation HYVideoHardEncodeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSession];
}

- (void)setupSession{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    if (inputError) {
        [JRToast showWithText:inputError.description duration:2];
        return;
    }
    
    AVCaptureVideoDataOutput *videoOutput = [AVCaptureVideoDataOutput new];
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    dispatch_queue_t videoQueue = dispatch_queue_create("video queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInteger:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferWidthKey : [NSNumber numberWithInteger:320], (id)kCVPixelBufferHeightKey : [NSNumber numberWithInteger:480]};
    
    AVCaptureSession *session = [AVCaptureSession new];
    //设置采集分辨率
    session.sessionPreset = AVCaptureSessionPresetHigh;
    //设置session的input output
    [session addInput:input];
    [session addOutput:videoOutput];
    
    //设置预览层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 150);
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    [session startRunning];
}

#pragma mark - AVCaptureOutputDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //摄像头采集到的是CMSampleBufferRef,未编码的数据
    [self videoEncode:sampleBuffer];
}

- (void)videoEncode:(CMSampleBufferRef)sampleBuffer{
    
    // CVPixelBufferRef 编码前图像数据结构
    // 利用给定的接口函数CMSampleBufferGetImageBuffer从中提取出CVPixelBufferRef
    CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CMTime presentationTimeStamp = CMTimeMake(_frameID++, 1000);
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
