//
//  TFAssistantTypeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
    AssistantStatusTypeUnread,  // 未读
    AssistantStatusTypeRead,    // 已读
    AssistantStatusTypeHandle   // 待处理
}AssistantStatusType;

@interface TFAssistantTypeController : HQBaseViewController
/** 类型 */
@property (nonatomic, assign) AssistantStatusType type;

/** 助手类型 */
@property (nonatomic, assign) AssistantType assistantType;

/**conversation */
@property (nonatomic, strong) JMSGConversation *conversation;

@end
