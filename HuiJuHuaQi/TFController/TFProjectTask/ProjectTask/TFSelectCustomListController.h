//
//  TFSelectCustomListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFModuleModel.h"

@interface TFSelectCustomListController : HQBaseViewController

/** module */
@property (nonatomic, strong) TFModuleModel *module;

/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;

/** isSingle */
@property (nonatomic, assign) BOOL isSingle;


@end
