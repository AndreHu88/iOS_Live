//
//  HYTCPSocketResponse.h
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYSocketConfig.h"

@interface HYTCPSocketRequest : NSObject

+ (instancetype)requestWithUrl:(TCPSocketRequestType)requestType parameters:(NSDictionary *)parameters header:(NSDictionary *)header;

@property (nonatomic,assign) NSInteger requestIdentifier;


- (NSData *)requestData;

@end


@interface HYTCPSocketResponse : NSObject

+ (instancetype)responseWithData:(NSData *)data;

- (TCPSocketRequestType)requestUrl;

- (NSData *)contentData;

- (uint32_t)serialNum;

- (uint32_t)statusCode;

@end
