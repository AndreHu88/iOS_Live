//
//  VideoEncodeHandle.h
//  live
//
//  Created by Duntech on 2018/6/20.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface VideoEncodeHandle : NSObject

@property (nonatomic,assign) int64_t frameID;

@property (nonatomic,strong) NSFileHandle *fileHandle;

@property (nonatomic,assign) VTCompressionSessionRef encodingSession;

@property (nonatomic,strong) dispatch_queue_t encodeQueue;

/** 编码sampleBuffer */
- (void)videoEncodeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/** 设置videoToolbox */
- (void)setupVideoToolbox;

/** 结束编码 */
- (void)endVideoToolbox;

@end
