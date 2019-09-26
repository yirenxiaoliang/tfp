//
//  TFSearchChatItemController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSearchChatItemController : HQBaseViewController

/** 0:聊天记录 1:小助手 */
@property (nonatomic, assign) NSInteger type;
/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, strong) NSNumber *chatId;


@end
