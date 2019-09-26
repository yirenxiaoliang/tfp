//
//  TFIMContentData.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFIMHeadData.h"
#import "TFChatMsgModel.h"
#import "TFAssistantPushModel.h"

@interface TFIMContentData : TFIMHeadData

@property (nonatomic, strong) TFChatMsgModel *content;

@property (nonatomic, strong) TFAssistantPushModel *pushMessage;

/** 接收内容 */
+(TFIMContentData *)recieveContentDataWithData:(NSData *)contentData;

/** 接收推送消息 */
+(TFIMContentData *)recievePushDataWithData:(NSData *)contentData;

-(NSData *)sendContentDataWithHeader:(NSData *)headData;

+ (TFIMContentData *)contentDataWithHeadData:(TFIMHeadData *)headData;


/** 将内容转为字符串 */
+ (NSString *)stringWithContentData:(TFIMContentData *)content;



/** 将字符串转为内容 */
+ (TFIMContentData *)contentDataWithString:(NSString *)content;

@end
