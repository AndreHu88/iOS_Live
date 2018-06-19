//
//  HYVideoHardEncodeVC.m
//  live
//
//  Created by Duntech on 2018/6/14.
//  Copyright © 2018年 胡勇. All rights reserved.
//
//  VideoToolbox数据结构
/**
 CVPixelBuffer：编码前和解码后的图像数据结构。此内容包含一系列的CVPixelBufferPool内容
 
 CMTime、CMClock和CMTimebase：时间戳相关。时间以64-bit/32-bit的形式出现。
 
 pixelBufferAttributes:字典设置.可能包括Width/height、pixel format type、• Compatibility (e.g., OpenGL ES, Core Animation)
 
 CMBlockBuffer：编码后，结果图像的数据结构。
 
 CMVideoFormatDescription：图像存储方式，编解码器等格式描述。
 
 (CMSampleBuffer：存放编解码前后的视频图像的容器数据结构。
 
 CMClock
 
 CMTimebase: 关于CMClock的一个控制视图,包含CMClock、时间映射(Time mapping)、速率控制(Rate control)
 
 H264中定义三种帧:
 I帧：完整编码的帧叫I帧
 P帧：参考之前的I帧生成的只包含差异部分编码的帧叫P帧
 B帧：参考前后的帧编码的帧叫B帧
 
 H264采用的核心算法是帧内压缩和帧间压缩
 帧内压缩是生成I帧的算法
 帧间压缩是生成B帧和P帧的算法
 
 H.264详细讲解blog
 https://www.jianshu.com/p/9edd9619e233?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
 */

#import "HYVideoHardEncodeVC.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface HYVideoHardEncodeVC () <AVCaptureVideoDataOutputSampleBufferDelegate>

/** 会话对象 */
@property (nonatomic,strong) AVCaptureSession *session;
/** previewLayer */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) int64_t frameID;
@property (nonatomic,strong) UIButton *startRecordBtn;
/** 是否开始录制 */
@property (nonatomic,assign) BOOL isStartRecord;
@property (nonatomic,strong) dispatch_queue_t encodeQueue;
@property (nonatomic,strong) dispatch_queue_t captureQueue;
@property (nonatomic,strong) NSFileHandle *fileHandle;

@end

@implementation HYVideoHardEncodeVC{
    
    VTCompressionSessionRef _encodeingSession;
    CMFormatDescriptionRef format;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    [self setupSession];
    [self setupSubviews];
    
}

- (void)initData{
    
    _encodeQueue = dispatch_queue_create("encode queue", DISPATCH_QUEUE_CONCURRENT);
    _captureQueue = dispatch_queue_create("capture queue", DISPATCH_QUEUE_CONCURRENT);
}

- (void)setupSubviews{
    
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.startRecordBtn];
    
    [_startRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-KAdaptedWidth(40));
        make.size.mas_equalTo(CGSizeMake(KAdaptedWidth(60), KAdaptedWidth(60)));
        make.left.mas_equalTo(KSCREEN_WIDTH / 3 - KAdaptedWidth(30));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.startRecordBtn);
        make.left.mas_equalTo(KSCREEN_WIDTH / 3 * 2 - KAdaptedWidth(30));
    }];
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
    [videoOutput setSampleBufferDelegate:self queue:_captureQueue];
    [videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    _session = [AVCaptureSession new];
    //设置采集分辨率
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    //设置session的input output
    [_session addInput:input];
    [_session addOutput:videoOutput];
    
    //设置预览层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT - 150);
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
    
    //创建文件，初始化fileHandle;
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.h264"];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
    
    
    [_session startRunning];
    [self setupVideoToolbox];
}

- (void)stopCapture{
    
    [_session stopRunning];
    [_previewLayer removeFromSuperlayer];
    [_fileHandle closeFile];
    _fileHandle = nil;
}

- (void)setupVideoToolbox{
    
    dispatch_sync(_encodeQueue, ^{
        
        int width = 720, height = 1280;
        OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, encodeComplectionCallback, (__bridge void *)(self), &_encodeingSession);
        DLog(@"status code is %d",(int)status);
        if (status != 0) {
            DLog(@"create H264 session error");
            return ;
        }
        
        //设置实时编码，避免延迟
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
        
        //设置关键帧间隔（） 关键帧间隔越小越清晰
        int frameInterval = 30;
        CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        
        //设置期望帧率(每秒多少帧,如果帧率过低,会造成画面卡顿)
        int fps = 30;
        CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
        
        //设置码率，均值，单位是byte
        int bitRate = width * height * 3 * 4 * 8;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        
        //设置码率上限，单位是bps
        int bitRateMax = width * height * 3 * 4;
        CFNumberRef bitRateMaxRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateMax);
        VTSessionSetProperty(_encodeingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateMaxRef);
        
        //准备编码
        VTCompressionSessionPrepareToEncodeFrames(_encodeingSession);
    });
}

- (void)endVideoToolbox{
    
    VTCompressionSessionCompleteFrames(_encodeingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(_encodeingSession);      //销毁session
    CFRelease(_encodeingSession);       //释放资源
    _encodeingSession = NULL;
}

#pragma mark - encodeCallback
//当系统编码完每一帧后，会异步的调用此方法
void encodeComplectionCallback(void * CM_NULLABLE outputCallbackRefCon,
                               void * CM_NULLABLE sourceFrameRefCon,
                               OSStatus status,
                               VTEncodeInfoFlags infoFlags,
                               CM_NULLABLE CMSampleBufferRef sampleBuffer ){
    
    
    DLog(@"didCompressH264 called with status %d infoFlags %d", (int)status, (int)infoFlags);
    if (status != noErr)    return;
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        
        NSLog(@"compressH264 data is not ready ");
        return;
    }
    
    //将C语言指针转化为当前VC
    HYVideoHardEncodeVC *encoderVC = (__bridge HYVideoHardEncodeVC *)outputCallbackRefCon;
    CFDictionaryRef dictRef = CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0);
    bool iskeyFrame = CFDictionaryContainsKey(dictRef, kCMSampleAttachmentKey_NotSync);
    //判断是否为关键帧
    if (iskeyFrame) {
        
        //获取编码后的信息
        CMFormatDescriptionRef formatRef = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t spsParameterSetSizeOut,spsParameterSetCountOut;
        const uint8_t *spsParameterSetPointerOut;
        //returns the NAL unit at the given index from it.  These NAL units are typically parameter sets (e.g. SPS, PPS)
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatRef, 0, &spsParameterSetPointerOut, &spsParameterSetSizeOut, &spsParameterSetCountOut, 0);
        if (statusCode == noErr) {
            //序列参数集SPS 作用于一系列连续的编码图像,检查PPS
            size_t ppsParameterSetSizeOut,ppsParameterSetCountOut;
            const uint8_t *ppsParameterSetPointerOut;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatRef, 1, &ppsParameterSetPointerOut, &ppsParameterSetSizeOut, &ppsParameterSetCountOut, 0);
            if (statusCode == noErr) {
                //图像参数集PPS 作用于编码视频序列中一个或多个独立的图像
                NSData *spsData = [NSData dataWithBytes:spsParameterSetPointerOut length:spsParameterSetSizeOut];
                NSData *ppsData = [NSData dataWithBytes:ppsParameterSetPointerOut length:ppsParameterSetSizeOut];
                if (encoderVC) {
                    [encoderVC handleEncodeDataSps:spsData ppsData:ppsData];
                }
            }
        }
    }
    
    //CMBlockBufferRef已经压缩的图像数据
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t bufferOffset = 0,lengthAtOffset,totalLength;
    char *dataPointer;
    OSStatus statusCode = CMBlockBufferGetDataPointer(dataBuffer, 0, &lengthAtOffset, &totalLength, &dataPointer);
    if (statusCode == noErr) {
        
        /**
         一个完整的H.264/ AVC bitstream是由多个NAL-units所组成的, NAL 网络提取层
         H.264的功能分为两层，视频编码层（VCL）和网络提取层（NAL）VCL数据即被压缩编码后的视频数据序列。在VCL数据要封装到NAL单元中之后，才可以用来传输或存储。
         */
        
        static const int AVCCHeaderLength = 4; // 返回的NALU数据前四个字节不是0001的startcode，而是大端模式的帧长度length
        //循环读取NALU数据
        while(totalLength - AVCCHeaderLength > bufferOffset) {
            
            uint32_t NALUUintLength = 0;
            memcpy(&NALUUintLength, dataPointer + bufferOffset, AVCCHeaderLength);
            //从大端转系统端 以大端字节序表示。直接赋值给整型变量
            NALUUintLength = CFSwapInt32BigToHost(NALUUintLength);
            NSData *data = [NSData dataWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUUintLength];
            [encoderVC encodeData:data isKeyFrame:iskeyFrame];
            //读取下一个NALU，一次回调可能包含多个NALU
            bufferOffset += AVCCHeaderLength + NALUUintLength;
        }
    }
    
}

//处理SPS PPS data
- (void)handleEncodeDataSps:(NSData *)spsData ppsData:(NSData *)ppsData{
    
    DLog(@"got SPS: %d  PPS :%d", (int)[spsData length], (int)[ppsData length]);
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    [_fileHandle writeData:ByteHeader];
    [_fileHandle writeData:spsData];
    [_fileHandle writeData:ByteHeader];
    [_fileHandle writeData:ppsData];
}

- (void)encodeData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame{
    
    if (_fileHandle) {
        
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        [_fileHandle writeData:ByteHeader];
        [_fileHandle writeData:data];
    }
}

#pragma mark - AVCaptureOutputDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (!_isStartRecord) return;
    //摄像头采集到的是CMSampleBufferRef,编码每一帧
    dispatch_sync(_encodeQueue, ^{
       
        //开启线程来编码，防止阻塞主线程摄像头卡顿
        [self videoEncode:sampleBuffer];

    });
}

- (void)videoEncode:(CMSampleBufferRef)sampleBuffer{
    
    // CVPixelBufferRef 编码前图像数据结构
    // 利用给定的接口函数CMSampleBufferGetImageBuffer从中提取出CVPixelBufferRef
    CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    // 帧时间 如果不设置导致时间轴过长
    CMTime presentationTimeStamp = CMTimeMake(_frameID++, 1000);
    //flags 0 表示同步解码
    VTEncodeInfoFlags flags;
    OSStatus status = VTCompressionSessionEncodeFrame(_encodeingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL, &flags);
    DLog(@"status code is %d",(int)status);
    if (status == noErr) {
        DLog(@"H264 VTCompressionSessionEncodeFrame success");
    }
    else{
        DLog(@"H264: VTCompressionSessionEncodeFrame failed with %d", (int)status);
        if (!_encodeingSession) return;
        VTCompressionSessionInvalidate(_encodeingSession);
        //释放资源
        CFRelease(_encodeingSession);
        _encodeingSession = NULL;
    }
}

#pragma mark - action
- (void)closeBtnAction{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.closeBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
    } completion:^(BOOL finished) {
        self.closeBtn.transform = CGAffineTransformIdentity;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)startRecordBtnAction{
    
    _isStartRecord = !_isStartRecord;
    NSString *toastStr = _isStartRecord ? @"开始录制，编码" : @"结束录制，编码";
    [JRToast showWithText:toastStr duration:2];
    
    
}

#pragma mark - lazyload
- (UIButton *)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)startRecordBtn{
    
    if (!_startRecordBtn) {
        _startRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startRecordBtn setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_startRecordBtn addTarget:self action:@selector(startRecordBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRecordBtn;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
