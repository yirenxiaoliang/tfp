//
//  TFSingleChatDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSingleChatDetailController : HQBaseViewController

@property (nonatomic,weak) JMSGConversation *conversation;
@property (nonatomic,strong) NSMutableArray <__kindof JMSGUser *>*memberArr;

/** gruopType */
@property (nonatomic, assign) NSInteger gruopType;


/** 刷新block */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
