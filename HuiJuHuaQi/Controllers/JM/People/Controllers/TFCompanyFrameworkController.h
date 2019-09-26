//
//  TFCompanyFrameworkController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCompanyFrameworkController : HQBaseViewController

/** type 0:组织架构 1：选择人员 2：选择部门 */
@property (nonatomic, assign) NSInteger type;

/** 值 */
@property (nonatomic, copy) ActionParameter action;

@end
