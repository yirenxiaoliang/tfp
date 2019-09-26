//
//  TFEmailApprovalController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFApprovalListItemModel.h"

@interface TFEmailApprovalController : HQBaseViewController


/** type 0:我发起的 1：待我审批 2：我已审批 3：抄送到我 */
@property (nonatomic, assign) NSInteger listType;


/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;


/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 删除 */
@property (nonatomic, copy) ActionHandler deleteAction;

/** 导航栏透明 */
@property (nonatomic, assign) BOOL translucent;

@end
