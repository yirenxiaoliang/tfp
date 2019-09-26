//
//  TFApprovalListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFModuleModel.h"

@interface TFApprovalListController : HQBaseViewController

/** quote */
@property (nonatomic, assign) BOOL quote;


/** type 0:我发起的 1：待我审批 2：我已审批 3：抄送给我 */
@property (nonatomic, strong) NSNumber *type;

/** module */
@property (nonatomic, copy) TFModuleModel *module;

/** refreshAction */
@property (nonatomic, copy) ActionParameter refreshAction;


/** selectApps  */
@property (nonatomic, strong) NSMutableArray *allSelects;

/** special */
@property (nonatomic, assign) BOOL special;

@end
