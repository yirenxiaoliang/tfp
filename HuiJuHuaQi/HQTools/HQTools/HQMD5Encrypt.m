//
//  HQMD5Encrypt.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/3/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMD5Encrypt.h"
#import "CommonCrypto/CommonDigest.h"

@implementation HQMD5Encrypt

//入参MD5加密
+ (NSString *)encodeByMD5WithString: (NSString *) inPutText
{
    if (inPutText.length == 0) {
        return @"";
    }
    
    const char *cStr = [inPutText UTF8String];
    unsigned  char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSString *string =  [[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]] lowercaseString];
    NSString *desString = [string lowercaseString];
    return desString;
    
    //    NSData *data = [[self class] hexToBytesByString:string];
    //    NSData *sData = [JKKBase64 encodeData:data];
    //
    //    NSString * num = [[NSString alloc] initWithData:sData encoding:NSUTF8StringEncoding];
    
    //    return num;
}


@end
