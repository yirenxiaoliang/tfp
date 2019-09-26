//
//  TFIMHIstoryContentData.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMHistoryData.h"
#import "TFChatMsgModel.h"

@interface TFIMHIstoryContentData : TFIMHistoryData

@property (nonatomic, strong) TFChatMsgModel *historyData;
/** 接收历史消息内容 */
+(TFIMHIstoryContentData *)receiveHistoryData:(NSData *)contentData;

/** 历史消息类型 */
+ (uint8_t)historyInfoTypeData:(NSData *)contentData;

/** 历史消息总数 */
+ (uint16_t)historyInfoSumcountData:(NSData *)contentData;

/** 历史消息当前数 */
+ (uint16_t)historyInfoNowcountData:(NSData *)contentData;

@end
