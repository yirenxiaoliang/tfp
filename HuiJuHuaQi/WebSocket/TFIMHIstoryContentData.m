//
//  TFIMHIstoryContentData.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMHIstoryContentData.h"

@implementation TFIMHIstoryContentData

/** 接收历史消息内容 */
+(TFIMHIstoryContentData *)receiveHistoryData:(NSData *)contentData {
    
    TFIMHistoryData *head = [TFIMHistoryData historyWithData:contentData];
    
    TFIMHIstoryContentData *content = [self historyDataWithHeadData:head];
    
    NSData *data = [contentData subdataWithRange:(NSRange){54,contentData.length-54}];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    content.historyData = [[TFChatMsgModel alloc] initWithDictionary:[HQHelper dictionaryWithJsonString:str] error:nil];
    
    return content;
}

/** 历史消息类型 */
+ (uint8_t)historyInfoTypeData:(NSData *)contentData {
    
    uint8_t msgType;
    // 包头结构体（49字节）+ 返回历史消息的结构体（5字节）
        
    [contentData getBytes:&msgType range:(NSRange){49,1}];
    
    return msgType;
    
}

/** 历史消息总数 */
+ (uint16_t)historyInfoSumcountData:(NSData *)contentData {

    uint16_t sumCount;
    
    [contentData getBytes:&sumCount range:(NSRange){50,2}];
    
    return sumCount;
}

/** 历史消息当前数 */
+ (uint16_t)historyInfoNowcountData:(NSData *)contentData {

    uint16_t nowCount;
    
    [contentData getBytes:&nowCount range:(NSRange){52,2}];
    
    return nowCount;
}

//历史消息
+ (TFIMHIstoryContentData *)historyDataWithHeadData:(TFIMHistoryData *)headData{
    TFIMHIstoryContentData *data = [[TFIMHIstoryContentData alloc] init];
    
    data.OneselfIMID = headData.OneselfIMID;
    data.usCmdID = headData.usCmdID;
    data.ucVer = headData.ucVer;
    data.ucDeviceType = headData.ucDeviceType;
    data.ucFlag = headData.ucFlag;
    data.ServerTimes = headData.ServerTimes;
    data.senderID = headData.senderID;
    data.receiverID = headData.receiverID;
    data.clientTimes = headData.clientTimes;
    data.RAND = headData.RAND;
    
    data.MsgType = headData.MsgType;
    data.SumCount = headData.SumCount;
    data.NowCount = headData.NowCount;
    
    return data;
}

@end
