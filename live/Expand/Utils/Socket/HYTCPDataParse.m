//
//  HYTCPDataParse.m
//  live
//
//  Created by Duntech on 2018/7/6.
//  Copyright © 2018 胡勇. All rights reserved.
//

#import "HYTCPDataParse.h"

@implementation HYTCPDataFormatter

+ (uint32_t)messageTypeFromData:(NSData *)data{
    
    return [self _integerFromDataLength4:data];
}

+ (NSData *)messageTypeDataFromType:(uint32_t)type{
    
    return [self _data4FromInt:type];
}

+ (uint32_t)messageSerialNumFromData:(NSData *)data{
    
    return [self _integerFromDataLength4:data];
}

+ (NSData *)messageSerialNumDataFromInt:(uint32_t)serialNum{
    
    return [self _data4FromInt:serialNum];
}

+ (NSData *)messageResponseCodeFromInt:(uint32_t)responseCode{
    
    return [self _data4FromInt:responseCode];
}

+ (uint32_t)messageResponseCodeFromData:(NSData *)data{
    
    return [self _integerFromDataLength4:data];
}

+ (NSData *)messageContentLengthFromInt:(uint32_t)contentLength{
    
    return [self _data4FromInt:contentLength];
}

+ (uint32_t)messageContentLengthFromData:(NSData *)data{
    
    return [self _integerFromDataLength4:data];
}


//将4位的data转成int数值
+ (uint32_t)_integerFromDataLength4:(NSData *)data{
    
    char *dataChar = (char *)data.bytes;
    char *index = (char *)&dataChar;
    char typeChar[4] = {0};
    for (int i = 0 ; i < data.length; i++) {
        typeChar[4 - 1 - i] = dataChar[i];
        index ++;
    }
    
    int integer;
    NSData *typeData = [NSData dataWithBytes:typeChar length:4];
    [typeData getBytes:&integer length:4];
    return integer;
}

+ (NSData *)_data4FromInt:(uint32_t)intNumber{
    
    char *p_int = (char *)&intNumber;
    static char int_str[4] = {0};
    for(int i = 4 - 1; i >= 0; i--) {
        int_str[i] = *p_int;
        p_int ++;
    }
    return [NSData dataWithBytes:&int_str length:4];
}


@end

@implementation HYTCPDataParse

+ (uint32_t)responseHeaderLength{
    
    return SocketMsgResponseHeaderLenght;
}

+ (uint32_t)responseUrlFromData:(NSData *)data{
    
    NSData *requestTypeData = [data subdataWithRange:NSMakeRange(0, SocketRequestTypeLength)];
    return [HYTCPDataFormatter messageTypeFromData:requestTypeData];
}

+ (uint32_t)responseSerialNumberFromData:(NSData *)data{
    
    NSData *subData = [data subdataWithRange:NSMakeRange(SocketRequestTypeLength, SocketMsgSerialNumberLength)];
    return [HYTCPDataFormatter messageSerialNumFromData:subData];
}

+ (uint32_t)responseCodeFromData:(NSData *)data{
    
    NSData *subData = [data subdataWithRange:NSMakeRange(SocketRequestTypeLength + SocketMsgSerialNumberLength, SocketMsgResponseCodeLength)];
    return [HYTCPDataFormatter messageResponseCodeFromData:subData];
}

+ (uint32_t)responseContentLengthFromData:(NSData *)data{
    
    NSData *subData = [data subdataWithRange:NSMakeRange(SocketRequestTypeLength + SocketMsgSerialNumberLength + SocketMsgResponseCodeLength, SocketMsgConentLength)];
    return [HYTCPDataFormatter messageContentLengthFromData:subData];
}

+ (NSData *)responseContentFromData:(NSData *)data{
    
    return [data subdataWithRange:NSMakeRange(SocketMsgResponseHeaderLenght, data.length - SocketMsgResponseHeaderLenght)];
}

@end
