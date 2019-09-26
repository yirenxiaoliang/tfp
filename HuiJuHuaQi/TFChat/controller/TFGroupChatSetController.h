//
//  TFGroupChatSetController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFGroupChatSetController : HQBaseViewController

@property (nonatomic,weak) JMSGConversation *conversation;
@property (nonatomic,strong) NSMutableArray <__kindof JMSGUser *>*memberArr;

/** gruopType */
@property (nonatomic, assign) NSInteger gruopType;

/** 刷新block */
@property (nonatomic, copy) Action refreshAction;

/** 群聊id */
@property (nonatomic, strong) NSNumber *groupId;

/** 聊天类型 */
@property (nonatomic, strong) NSNumber *chatType;

@end
