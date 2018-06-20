//
//  VideoEncodeHandle.m
//  live
//
//  Created by Duntech on 2018/6/20.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import "VideoEncodeHandle.h"

@implementation VideoEncodeHandle

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _encodeQueue = dispatch_queue_create("encode queue", DISPATCH_QUEUE_CONCURRENT);
        [self setupVideoToolbox];
    }
    return self;
}

- (void)setupVideoToolbox{
    
    dispatch_sync(_encodeQueue, ^{
        
        [self setupFileHandle];
        
        int width = 720, height = 1280;
        OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, encodingComplectionCallback, (__bridge void *)(self), &_encodingSession);
        DLog(@"status code is %d",(int)status);
        if (status != 0) {
            DLog(@"create H264 session error");
            return ;
        }
        
        //设置实时编码，避免延迟
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
        
        //设置关键帧间隔（）关键字间隔越小越清晰，数值越大压缩率越高
        int frameInterval = 1;
        CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        
        //设置期望帧率
        int fps = 30;
        CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
        
        //设置码率，均值，单位是byte
        int bitRate = width * height * 3 * 4 * 8;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        
        //设置码率上限，单位是bps,如果不设置默认会以很低的码率编码，导致编码出来的视频很模糊
        int bitRateMax = width * height * 3 * 4;
        CFNumberRef bitRateMaxRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateMax);
        VTSessionSetProperty(_encodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateMaxRef);
        
        //准备编码
        VTCompressionSessionPrepareToEncodeFrames(_encodingSession);
        
    });
}

- (void)setupFileHandle{
    
    //创建文件，初始化fileHandle;
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.h264"];
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
}

#pragma mark - publicMethod
- (void)endVideoToolbox{
    
    VTCompressionSessionCompleteFrames(_encodingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(_encodingSession);      //销毁session
    CFRelease(_encodingSession);       //释放资源
    _encodingSession = NULL;
    
    [_fileHandle closeFile];
    _fileHandle = nil;
}

- (void)videoEncodeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    dispatch_sync(_encodeQueue, ^{
        
        // CVPixelBufferRef 编码前图像数据结构
        // 利用给定的接口函数CMSampleBufferGetImageBuffer从中提取出CVPixelBufferRef
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        // 帧时间 如果不设置导致时间轴过长
        CMTime presentationTimeStamp = CMTimeMake(_frameID++, 1000);
        //flags 0 表示同步解码
        VTEncodeInfoFlags flags;
        OSStatus status = VTCompressionSessionEncodeFrame(_encodingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL, &flags);
        DLog(@"status code is %d",(int)status);
        if (status == noErr) {
            DLog(@"H264 VTCompressionSessionEncodeFrame success");
        }
        else{
            DLog(@"H264: VTCompressionSessionEncodeFrame failed with %d", (int)status);
            if (!_encodingSession) return;
            VTCompressionSessionInvalidate(_encodingSession);
            //释放资源
            CFRelease(_encodingSession);
            _encodingSession = NULL;
        }
    });
    
}

#pragma mark - encodeCallback
//每压缩一次都异步的调用此方法
void encodingComplectionCallback(void * CM_NULLABLE outputCallbackRefCon,
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
    VideoEncodeHandle *encodeHandle = (__bridge VideoEncodeHandle *)outputCallbackRefCon;
    CFDictionaryRef dictRef = CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0);
    bool iskeyFrame = !CFDictionaryContainsKey(dictRef, kCMSampleAttachmentKey_NotSync);
    //判断是否为关键帧
    if (iskeyFrame) {
        
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
                if (encodeHandle) {
                    [encodeHandle handleEncodeDataSps:spsData ppsData:ppsData];
                }
            }
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t bufferOffset = 0,lengthAtOffset,totalLength;
    char * dataPointer;
    OSStatus statusCode = CMBlockBufferGetDataPointer(dataBuffer, 0, &lengthAtOffset, &totalLength, &dataPointer);
    if (statusCode == noErr) {
        
        static const int AVCCHeaderLength = 4; // 返回的NALU数据前四个字节不是0001的startcode，而是大端模式的帧长度length
        while(totalLength - AVCCHeaderLength > bufferOffset) {
            
            uint32_t NALUUintLength = 0;
            memcpy(&NALUUintLength, dataPointer + bufferOffset, AVCCHeaderLength);
            //从大端转系统端
            NALUUintLength = CFSwapInt32BigToHost(NALUUintLength);
            NSData *data = [NSData dataWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUUintLength];
            [encodeHandle encodeData:data isKeyFrame:iskeyFrame];
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
    if(!_fileHandle) return;
    [_fileHandle writeData:ByteHeader];
    [_fileHandle writeData:spsData];
    [_fileHandle writeData:ByteHeader];
    [_fileHandle writeData:ppsData];
}

- (void)encodeData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame{
    
    DLog(@"getEncodedData:%d", (int)[data length]);
    if (_fileHandle) {
        
        const char bytes[] = "\x00\x00\x00\x01";   //00000001
        size_t length = (sizeof bytes) - 1; //string literals have implicit trailing '\0'
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        [_fileHandle writeData:ByteHeader];
        [_fileHandle writeData:data];
    }
}

@end
