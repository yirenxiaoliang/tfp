//
//  NSString+AES.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/24.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AES)

/** 128位加密 */
-(NSString *) aes128Encrypt:(NSString *)key;
/** 128位解密 */
-(NSString *) aes128Decrypt:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
