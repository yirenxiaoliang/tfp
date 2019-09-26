//
//  TFGroupPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//  群聊人员

#import "HQBaseViewController.h"



@interface TFGroupPeopleController : HQBaseViewController

/** type 0:显示所有 1：移除 2:AT 3:转让群主 */
@property (nonatomic, assign) NSInteger type;

/** 0:普通push 1:@进来 */
@property (nonatomic, assign) NSInteger isAT;

@property (nonatomic, strong) NSNumber *groupId;

@property (nonatomic,strong) NSMutableArray *memberArr;

@property (nonatomic, copy ) ActionParameter actionParameter;

@property (nonatomic, copy )  ActionHandler actionHandler;
@end
