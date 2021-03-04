//
//  TFIMContentData.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMContentData.h"


#define Separate1 @"$$##$$"
#define Separate2 @"&&**&&"

@implementation TFIMContentData

/** 接收内容 */
+(TFIMContentData *)recieveContentDataWithData:(NSData *)contentData {

    
    TFIMHeadData *head = [TFIMHeadData headerWithData:contentData];
    
    TFIMContentData *content = [self contentDataWithHeadData:head];
    
    
    NSData *data = [contentData subdataWithRange:(NSRange){49,contentData.length-49}];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([str containsString:@"\"atList\":\"\""]) {
        
        NSMutableString *stttt = [NSMutableString stringWithString:str];
        
        [stttt replaceCharactersInRange:[str rangeOfString:@"\"atList\":\"\""] withString:@"\"atList\":[]"];
        
        str = stttt;
        
        
    }
    
    content.content = [[TFChatMsgModel alloc] initWithDictionary:[HQHelper dictionaryWithJsonString:str] error:nil];
    
    
    
    return content;
}

/** 接收推送消息 */
+(TFIMContentData *)recievePushDataWithData:(NSData *)contentData {

    TFIMHeadData *head = [TFIMHeadData headerWithData:contentData];
    
    TFIMContentData *content = [self contentDataWithHeadData:head];
    
    NSData *data = [contentData subdataWithRange:(NSRange){49,contentData.length-49}];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    content.pushMessage = [[TFAssistantPushModel alloc] initWithDictionary:[HQHelper dictionaryWithJsonString:str] error:nil];
    
    return content;
}


/** 发送消息 */
-(NSData *)sendContentDataWithHeader:(NSData *)headData{
    
    NSMutableData *data = [NSMutableData dataWithData:headData];
    
    
    NSData *contentData = [self.content toJSONData] ;
    
    [data appendBytes:contentData.bytes length:contentData.length];
    
    
    
    return data;
}

//
+ (TFIMContentData *)contentDataWithHeadData:(TFIMHeadData *)headData{
    TFIMContentData *data = [[TFIMContentData alloc] init];
    
    data.OneselfIMID = headData.OneselfIMID;
    data.usCmdID = headData.usCmdID;
    data.ucVer = headData.ucVer;
//    data.ucDeviceType = headData.ucDeviceType;
    data.ucDeviceType = iOSDevice;
    data.ucFlag = headData.ucFlag;
    data.ServerTimes = headData.ServerTimes;
    data.senderID = headData.senderID;
    data.receiverID = headData.receiverID;
    data.clientTimes = headData.clientTimes;
    data.RAND = headData.RAND;
    
    return data;
}


+ (NSString *)stringWithContentData:(TFIMContentData *)content {

    NSString *str = @"";
    
    NSDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@(content.OneselfIMID) forKey:@"OneselfIMID"];
    [dict setValue:@(content.usCmdID) forKey:@"usCmdID"];
    [dict setValue:@(content.ucVer) forKey:@"ucVer"];
    [dict setValue:@(content.ucDeviceType) forKey:@"ucDeviceType"];
    [dict setValue:@(content.ucFlag) forKey:@"ucFlag"];
    [dict setValue:@(content.ServerTimes) forKey:@"ServerTimes"];
    [dict setValue:@(content.senderID) forKey:@"senderID"];
    [dict setValue:@(content.receiverID) forKey:@"receiverID"];
    [dict setValue:@(content.clientTimes) forKey:@"clientTimes"];
    [dict setValue:@(content.RAND) forKey:@"RAND"];
    [dict setValue:content.content forKey:@"content"];
    
    
    
    
    NSArray *properts = [dict allKeys];
    
    
    for (NSString* p in properts) {
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@",p,Separate2,[dict valueForKey:p],Separate1]];
        
    }
    
    if (str.length) {
        
        str = [str substringToIndex:str.length-1];
    }
    
    return str;
}



+ (TFIMContentData *)contentDataWithString:(NSString *)content{
    
    TFIMContentData *data = [[TFIMContentData alloc] init];
    
    
    NSArray *arr = [content componentsSeparatedByString:Separate1];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *str in arr) {
        
        NSArray *values = [str componentsSeparatedByString:Separate2];
        
        if (values.count == 2) {
            
            [dict setObject:values[1] forKey:values[0]];
            
        }
    }
    
    data.OneselfIMID = [[dict valueForKey:@"OneselfIMID"] integerValue];
    data.usCmdID = [[dict valueForKey:@"usCmdID"] integerValue];
    data.ucVer = [[dict valueForKey:@"ucVer"] integerValue];
//    data.ucDeviceType = [[dict valueForKey:@"ucDeviceType"] integerValue];
    data.ucDeviceType = iOSDevice;
    data.ucFlag = [[dict valueForKey:@"ucFlag"] integerValue];
    data.ServerTimes = [[dict valueForKey:@"ServerTimes"] integerValue];
    data.senderID = [[dict valueForKey:@"senderID"] integerValue];
    data.receiverID = [[dict valueForKey:@"receiverID"] integerValue];
    data.clientTimes = [[dict valueForKey:@"clientTimes"] integerValue];
    data.RAND = [[dict valueForKey:@"RAND"] unsignedIntValue];
    data.content = [dict valueForKey:@"content"];
    
    
    return data;
}








@end
