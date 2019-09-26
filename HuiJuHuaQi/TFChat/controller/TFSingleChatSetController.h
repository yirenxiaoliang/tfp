//
//  TFSingleChatSetController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSingleChatSetController : HQBaseViewController

@property (nonatomic, strong) NSNumber *chatId;

@property (nonatomic, strong) NSNumber *chatType;

@property (nonatomic,weak) JMSGConversation *conversation;
@property (nonatomic,strong) NSMutableArray <__kindof JMSGUser *>*memberArr;

/** gruopType */
@property (nonatomic, assign) NSInteger gruopType;


@end
