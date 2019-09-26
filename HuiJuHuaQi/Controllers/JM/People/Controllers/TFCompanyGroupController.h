//
//  TFCompanyGroupController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//  公司组织架构

#import "HQBaseViewController.h"

@interface TFCompanyGroupController : HQBaseViewController

/** 单选 默认多选*/
@property (nonatomic, assign) BOOL isSingle;


/** type 0:企业成员  1：成员管理 2:选择人员 */
@property (nonatomic, assign) NSInteger type;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

/** 选择的人员 */
@property (nonatomic, strong) NSArray *employees;


@end
