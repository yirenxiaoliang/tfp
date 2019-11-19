//
//  TFNewCustomDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFModuleModel.h"

@interface TFNewCustomDetailController : HQBaseViewController

@property (nonatomic, copy) NSString *bean;

/** id */
@property (nonatomic, strong) NSNumber *moduleId;

/** dataAuth 此条数据的权限 */
@property (nonatomic, copy) NSString *dataAuth;
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
