//
//  TFDepartmentManageController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFDepartmentManageController : HQBaseViewController

/** type 0:用于选择 1：管理 */
@property (nonatomic, assign) NSInteger type;
/** 多选 */
@property (nonatomic, assign) BOOL isMutiSelect;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

@end
