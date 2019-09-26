//
//  TFSelectChatPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSelectChatPeopleController : HQBaseViewController


/** peoples */
@property (nonatomic, strong) NSArray *peoples;

/** 多选 */
@property (nonatomic, assign) BOOL isSingle;

/** type 0:聊天 1：选人 */
@property (nonatomic, assign) NSInteger type;

/** 二次确认选人 */
@property (nonatomic, assign) BOOL isTwoSure;

/** 数据源 */
@property (nonatomic, strong) NSArray *dataPeoples;


/** 选择的人 */
@property (nonatomic, copy) ActionParameter actionParameter;
/** 自执行 */
@property (nonatomic, copy) ActionHandler action;

@end
