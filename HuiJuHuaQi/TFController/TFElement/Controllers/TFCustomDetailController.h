//
//  TFCustomDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFModuleModel.h"

@interface TFCustomDetailController : HQBaseViewController

/** bean */
@property (nonatomic, copy) NSString *bean;
/** moduleId */
@property (nonatomic, strong) NSNumber *moduleId;

/** id */
@property (nonatomic, strong) NSNumber *dataId;

/** isSeasAdmin 是否为公海池管理员 0：非 1：是 */
@property (nonatomic, copy) NSString *isSeasAdmin;

/** seaPoolId */
@property (nonatomic, strong) NSNumber *seaPoolId;

/** taskKey */
@property (nonatomic, copy) NSString *taskKey;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 删除 */
@property (nonatomic, copy) ActionHandler deleteAction;

@end
