//
//  TFAssistantSettingController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFAssistantTypeModel.h"

@interface TFAssistantSettingController : HQBaseViewController

/** 助手类型 */
@property (nonatomic, assign) AssistantType assistantType;

/**conversation */
@property (nonatomic, strong) JMSGConversation *conversation;

/** TFAssistantTypeModel */
@property (nonatomic, strong) TFAssistantTypeModel *typeModel;

@property (nonatomic, strong) NSNumber *assistantId;

@property (nonatomic, copy) ActionHandler refresh;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *icon_color;
@property (nonatomic, copy) NSString *icon_type;

@end
