//
//  TFAssistantMainController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "YPTabBarController.h"
#import "TFAssistantTypeModel.h"


@interface TFAssistantMainController : YPTabBarController

/** 助手类型 */
@property (nonatomic, assign) AssistantType assistantType;

/**conversation */
@property (nonatomic, strong) JMSGConversation *conversation;

/** TFAssistantTypeModel */
@property (nonatomic, strong) TFAssistantTypeModel *typeModel;

@end
