//
//  HYSocketConfig.h
//  live
//
//  Created by Duntech on 2018/7/5.
//  Copyright © 2018 胡勇. All rights reserved.
//

#ifndef HYSocketConfig_h
#define HYSocketConfig_h


#import "HYTCPDataParse.h"

//网络环境，配置成可灵活切换
typedef NS_ENUM(NSUInteger, HYTCPServerEnvironment) {
    HYTCPServerEnvironmentTest,
    HYTCPServerEnvironmentDevelop,
    HYTCPServerEnvironmentRelease,
};

//这里模拟多个TCP的server
typedef NS_ENUM(NSUInteger, HYTCPServerType) {
    HYTCPServerTypeShangHai,
    HYTCPServerTypeGuangZhou,
    HYTCPServerTypeHK,
};

//模拟socket网络请求类型
typedef NS_ENUM(NSUInteger, TCPSocketRequestType) {
    TCPSocketRequestTypeHeart = 0x00000001,
    TCPSocketRequestTypeLogin = 0x00000002,
    TCPSocketRequestTypeNotification = 0x00000003,
    TCPSocketRequestTypeStock = 0x00000400,
};

//枚举定义返回的code码
typedef NS_ENUM(NSUInteger, TCPSocketResponseCode) {
    TCPSocketResponseCodeSuccess = 200,
    TCPSocketResponseCodeError = 500,
    TCPSocketResponseCodeInvaildMsgLength = 501,
    TCPSocketResponseCodeUndefinedMsg = 502,
};

#define    SocketRequestTypeLength       4          //请求类型长度
#define    SocketMsgSerialNumberLength   4          //消息序列号长度
#define    SocketMsgResponseCodeLength   4          //返回状态码长度
#define    SocketMsgConentLength         4          //消息内容的长度
#define    SocketMsgResponseHeaderLenght        (SocketRequestTypeLength + SocketMsgSerialNumberLength + SocketMsgResponseCodeLength  + SocketMsgConentLength)                          //socket报文的头部长度


#define    TCPSocketHeartDetectInterval     10


#ifdef DEBUG
    #define DLog(format, ...) NSLog(@"%s():%d " format, __func__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

#endif /* HYSocketConfig_h */
