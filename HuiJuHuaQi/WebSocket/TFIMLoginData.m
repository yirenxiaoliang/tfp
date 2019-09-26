//
//  TFIMLoginData.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMLoginData.h"

@implementation TFIMLoginData

-(instancetype)init{
    if (self = [super init]) {
//        self.chStatus = 1;
//        self.chUserType = 1;
        self.TOKEN = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceToken];
    }
    return self;
}

/** 登录 */
-(NSData *)loginDataWithHeader:(NSData *)headData{
    
    NSMutableData *data = [NSMutableData dataWithData:headData];
    
//    for (NSInteger i = 0 ; i < self.szUsername.length; i++) {
//
//        char obj = [self.szUsername characterAtIndex:i];
//
//        [data appendBytes:&obj length:sizeof(obj)];
//
//    }
    
//    uint8_t chStatus = self.chStatus;
//    uint8_t chUserType = self.chUserType;
    
//    [data appendBytes:&chStatus length:sizeof(chStatus)];
//    [data appendBytes:&chUserType length:sizeof(chUserType)];
    
    for (NSInteger i = 0 ; i < self.TOKEN.length; i++) {
        
        char obj = [self.TOKEN characterAtIndex:i];
        
        [data appendBytes:&obj length:sizeof(obj)];
        
    }
    
    
    return data;
}

/** 登录是否成功 */
+(BOOL)isLoginSuccessWithData:(NSData *)data{
    
    BOOL success = NO;
    
    // 包头结构体（49字节）+ 登录返回结构体（4字节）
    if (data.length < 53) {
        success = NO;
    }
    
    int32_t login;
    
    [data getBytes:&login range:(NSRange){49,4}];
    
    if (login == 0) {
        success = YES;
    }
    
    return success;
}

/** 登录返回码 */
+(int32_t)loginResponseWithData:(NSData *)data{
    
    int32_t login;
    
    // 包头结构体（49字节）+ 登录返回结构体（4字节）
    if (data.length < 53) {
        login = -87;
    }else{
        
        [data getBytes:&login range:(NSRange){49,4}];
    }
    return login;
}



@end
