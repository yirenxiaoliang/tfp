//
//  TFChatPeopleInfoController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQEmployModel.h"
#import <JMessage/JMSGConstants.h>

@interface TFChatPeopleInfoController : HQBaseViewController

/** 是否为自己 */
@property (nonatomic, assign) BOOL isMyself;


/** HQEmployModel */
@property (nonatomic, strong) HQEmployModel *employee;

/** JMSGUser */
@property (nonatomic, strong) JMSGUser *jmsUser;


@end
