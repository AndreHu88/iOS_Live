//
//  AppConst.h
//  live
//
//  Created by Duntech on 2018/6/1.
//  Copyright © 2018年 胡勇. All rights reserved.
//

#ifndef AppConst_h
#define AppConst_h


/** RSA公钥 */
static NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl5RBHD3abOyeYCOLkaWkpJXgJQfMklOWPmdJAnG1eD6CV+UOpUKMy5LtfGHQEM7ao5x3BpMx4MNRUYVwBAmU84PhwNm6xpTJrg5zZCloFmsX+E5ukWE5YFRu8i5+5d8LuQTTTv4XfzbTCTOhON8uj+ypkomETuVNwgRFVFjHd1QIDAQAB";

/** RSA私钥 */
static NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOXlEEcPdps7J5gI4uRpaSkleAlB8ySU5Y+Z0kCcbV4PoJX5Q6lQozLku18YdAQztqjnHcGkzHgw1FRhXAECZTzg+HA2brGlMmuDnNkKWgWaxf4Tm6RYTlgVG7yLn7l3wu5BNNO/hd/NtMJM6E43y6P7KmSiYRO5U3CBEVUWMd3VAgMBAAECgYEAkqHVDQ4O35oOegmI9plJauYsNvNqqzWRalN5aJ6dn3YmPiI8Bt2ZClgcLt6A+UEmy3qGX0HG7Q5wD9X9geNOQB3ZiD/pGAGW08wS/wTxnWSnSBwdtZ03pUttfnFctkxULfDq4iG1ywdjqEk3F8QVFajQ0c76kWbt9LGAv2OGIi0CQQD2CmbVFXy4JeNHK3TDoLMjsUCiLa+qPnyyVDLDG9Ozb7wN2ydTrMhI+0udmjKvy/Lm1E2bKyp42iYuubEqvSAXAkEA7zNZsOgUe0q73sxXqrLQ7Fs7TNtIEXghrGmkVTHN0I7uMKzQ7KEbA6hfcBm4hPMoLa6Ag3m9tiMNBWtDWc/Y8wJAK0//dEl5EC3TSccTohCbGJBukV47i1u+teHuobw3U2I7F7FZxfgntflPAWqQu7PKieob01IRAv9cM2OLFbv/dwJBAIniXedeQMA5ekaaIEbjwQ8eH/bTyJ1ZVH/gfbwmc2+vlJo2ZFCjJcFcA3fJO9ZXnGeI2cfwG22sksr24+IXsAUCQG5yvVIleTDYqWuWVG1Rc8fk5UFjoZzJpp0nil0z+0fR5rogr4fxcH7vbWsE0id7gSvtV7KxPzkvJTpOK3yGDN0=";

/** 极光APPKey */
static NSString *JPushAppKey = @"58f4c12815f70887dd6ffd72";

static NSString *KUserModelData = @"userModelData";

static NSString *KUserInfo = @"userInfo";

//音乐播放完成
static NSString *KMusicPlayComplectionNotificationName = @"KMusicPlayComplectionNotificationName";

// SString这是运行时能获取到的C语言的类型
static NSString * const TYPE_UINT8   = @"TC";// char是1个字节，8位
static NSString * const TYPE_UINT16   = @"TS";// short是2个字节，16位
static NSString * const TYPE_UINT32   = @"TI";
static NSString * const TYPE_UINT64   = @"TQ";
static NSString * const TYPE_STRING   = @"T@\"NSString\"";
static NSString * const TYPE_ARRAY   = @"T@\"NSArray\"";

/// SSKeyChain常量
static NSString * const Service_Name = @"com.live.music";
static NSString * const User_Password = @"User_Password";
static NSString * const User_AccessToken = @"User_AccessToken";




#endif /* AppConst_h */
