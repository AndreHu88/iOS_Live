//
//  HYTCPDataParse.h
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//
//  Byte也就是unsigned char

/**
 TCP协议是可靠的传输协议(可靠意味着TCP实现会保证数据不会丢包, 也不会乱序),
 处理粘包:
 发送方:给每段数据都附上一份描述信息(描述信息主要包括数据的长度, 解析格式等等)
 接收方:就可以根据描述信息从一串数据流中分割出单独的每段应用层报文了
 
 报文:被传输数据和数据的描述一起构成了一段应用层报文, 这里我们称实际想传输的数据为报文有效载荷, 而数据的描述信息为报文头部.
 自定义简单的通讯协议:
 request:       4Byte       4Byte           4Byte           0 ~ N
                url         serNum     contentLength       content

 response:      4Byte       4Byte          4Byte            4Byte           0 ~ N
                url         serNum    responseCode    contentLength       content
 
 url: 类似HTTP中的统一资源定位符, 32位无符号整数(4个字节). 用于标识客户端请求的服务端资源或对资源进行的操作. 由服务端定义, 客户端使用.

 content(可选): 请求携带的数据, 0~N字节的二进制数据. 用于携带请求传输的内容, 传输的内容目前是请求参数, 也可能什么都没有. 解析格式固定为JSON.
 
 serNum: 请求序列号, 32位无符号整数(4个字节). 用于标示请求本身, 每个请求对应一个唯一的序列号, 即使两个请求的url和content都相同.  由客户端生成并传输, 服务端解析并回传. 客户端通过回传的序列号和请求序列号之间的对应关系进行响应数据分发.
 
 contentLen: 请求携带数据长度, 32位无符号整数(4个字节). 用于标示请求携带的数据的长度. 服务端通过contentLen将粘包的数据进行切割后一一解析并处理.
 
 还可以增加：ContentType  来确定数据传输的类型   version版本
 
 */
     


#import <Foundation/Foundation.h>
#import "HYSocketConfig.h"

@interface HYTCPDataFormatter : NSObject

/** msgType的NSData转换成int */
+ (uint32_t)messageTypeFromData:(NSData *)data;

/** msgType的uint32_t转换成NSData */
+ (NSData *)messageTypeDataFromType:(uint32_t)type;

/** 将序列号的data转成int */
+ (uint32_t)messageSerialNumFromData:(NSData *)data;

/** 将序列号的转成data */
+ (NSData *)messageSerialNumDataFromInt:(uint32_t)serialNum;

/** 将消息内容的长度的data转出int */
+ (uint32_t)messageContentLengthFromData:(NSData *)data;

/** 将消息内容的长度的int转成data */
+ (NSData *)messageContentLengthFromInt:(uint32_t)contentLength;

/** 将返回code码的data转出int */
+ (uint32_t)messageResponseCodeFromData:(NSData *)data;

/** 将返回code码的int转成data */
+ (NSData *)messageResponseCodeFromInt:(uint32_t)responseCode;

@end

@interface HYTCPDataParse : NSObject

/** 获取返回的报文头长度 */
+ (uint32_t)responseHeaderLength;

/** 获取请求类型 */
+ (uint32_t)responseUrlFromData:(NSData *)data;

+ (uint32_t)responseCodeFromData:(NSData *)data;

+ (uint32_t)responseSerialNumberFromData:(NSData *)data;

+ (uint32_t)responseContentLengthFromData:(NSData *)data;

+ (NSData *)responseContentFromData:(NSData *)data;


@end
