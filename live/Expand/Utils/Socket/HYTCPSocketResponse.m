//
//  HYTCPSocketResponse.m
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPSocketResponse.h"

@interface HYTCPSocketResponse ()

@property (nonatomic,strong) NSData *data;

@end

@implementation HYTCPSocketResponse

+ (instancetype)responseWithData:(NSData *)data{
    
    if (data.length < 20) return nil;
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
