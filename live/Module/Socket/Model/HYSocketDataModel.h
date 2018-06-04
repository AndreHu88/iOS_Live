//
//  HYSocketDataModel.h
//  live
//
//  Created by Duntech on 2018/6/4.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    socket传输协议 需要自定传输协议规则
    协议大概如下
    +-------------------------------------------------------+
    |   Total Length    |     Protobuf ID  |   ProtocolData |
    |   消息总长度        |     协议号        |     协议数据流   |
    |   4 bytes         |     2 bytes      |   可从数据中获取  |
    +-------------------------------------------------------+
 */

/**
     按照posix标准，一般整形对应的*_t类型为：
     1字节     uint8_t
     2字节     uint16_t
     4字节     uint32_t
     8字节     uint64_t
 */

@interface HYSocketDataModel : NSObject

@end

@interface HYSocketSendModel : NSObject

@property (nonatomic,assign) uint8_t sceneId;
@property (nonatomic,assign) uint32_t protobufId;
@property (nonatomic,copy)   NSString *message;

@end

@interface HYSocketReceiveModel : NSObject


@end


