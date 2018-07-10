//
//  HYTCPSocketResponse.m
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPSocketResponse.h"

@interface HYTCPSocketRequest ()

@property (nonatomic,strong) NSMutableData *formatData;

@end

@implementation HYTCPSocketRequest

+ (instancetype)requestWithUrl:(TCPSocketRequestType)requestType parameters:(NSDictionary *)parameters header:(NSDictionary *)header{
    
    if (requestType == TCPSocketRequestTypeHeart) {
        return [self heartDetectWithParameters:parameters];
    }
    
    DLog(@"发送socket请求:%@",parameters);
    HYTCPSocketRequest *request = [HYTCPSocketRequest new];
    
    NSData *content = [parameters modelToJSONData];
    uint32_t requestIdentifier = [self currentRequestIdentifier];
    request.requestIdentifier = requestIdentifier;

    //按照自定义的协议增加协议头信息
    [request.formatData appendData:[HYTCPDataFormatter messageTypeDataFromType:TCPSocketRequestTypeHeart]];
    [request.formatData appendData:[HYTCPDataFormatter messageSerialNumDataFromInt:requestIdentifier]];
    [request.formatData appendData:[HYTCPDataFormatter messageContentLengthFromInt:(int)content.length]];
    if (content.length > 0 && content != nil) {
        [request.formatData appendData:content];
    }
    return request;
}

+ (instancetype)heartDetectWithParameters:(NSDictionary *)parameters{
    
    DLog(@"发送心跳包:%@",parameters);
    HYTCPSocketRequest *request = [HYTCPSocketRequest new];
    request.requestIdentifier = TCPSocketRequestTypeHeart;

    uint32_t heartAckNum = [parameters[TCPHeartDetectAckKey] intValue];
    //按照自定义的协议增加协议头信息,发送心跳包
    [request.formatData appendData:[HYTCPDataFormatter messageTypeDataFromType:TCPSocketRequestTypeHeart]];
    [request.formatData appendData:[HYTCPDataFormatter messageSerialNumDataFromInt:heartAckNum]];
    [request.formatData appendData:[HYTCPDataFormatter messageContentLengthFromInt:0]];
    
    return request;
}

+ (uint32_t)currentRequestIdentifier{
    
    static uint32_t currentRequestIdentifer;
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        currentRequestIdentifer = TCPSocketRequestMinRequestIdentifier;
        semaphore = dispatch_semaphore_create(1);
    });
    //做资源互斥   此时信号量为1
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //wait -1 ,此时信号量为0，
    if (currentRequestIdentifer == 0xFFFFFFFF - 1) {
        //如果identifier为最大值了就重置
        currentRequestIdentifer = TCPSocketRequestMinRequestIdentifier;
    }
    currentRequestIdentifer += 1;
    dispatch_semaphore_signal(semaphore);       //信号量+1
    return currentRequestIdentifer;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _formatData = [NSMutableData data];
    }
    return self;
}


- (uint32_t)requestTimeOutInterval{
    
    return _requestTimeOutInterval > 0 ?: 10;
}

- (NSData *)requestData{
    
    return _formatData.copy;
}


@end

@interface HYTCPSocketResponse ()

@property (nonatomic,strong) NSData *data;

@end

@implementation HYTCPSocketResponse

+ (instancetype)responseWithData:(NSData *)data{
    
    if (data.length < [HYTCPDataParse responseHeaderLength]) return nil;
    HYTCPSocketResponse *response = [HYTCPSocketResponse new];
    response.data = data;
    return response;
}

- (TCPSocketRequestType)requestUrl{
    
    return [HYTCPDataParse responseUrlFromData:self.data];;
}

- (NSData *)contentData{
    
    return [HYTCPDataParse responseContentFromData:self.data];
}

- (uint32_t)serialNum{
    
    return [HYTCPDataParse responseSerialNumberFromData:self.data];
}

- (uint32_t)statusCode{
    
    return [HYTCPDataParse responseCodeFromData:self.data];
}


@end
