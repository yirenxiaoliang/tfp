//
//  TFApprovalDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceFieldModel.h"
#import "HQEmployModel.h"
#import "TFApprovalListItemModel.h"

@interface TFApprovalDetailController : HQBaseViewController

/** type 0:我发起的 1：待我审批 2：我已审批 3：抄送到我 */
@property (nonatomic, assign) NSInteger listType;

/** isReadRequest */
@property (nonatomic, assign) BOOL isReadRequest;


/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;


/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 删除 */
@property (nonatomic, copy) ActionHandler deleteAction;

/** 导航栏透明 */
@property (nonatomic, assign) BOOL translucent;


/** 关联数组 */
@property (nonatomic, strong) NSArray <TFRelevanceFieldModel *>*relevances;

/** HQEmployModel *emp */
@property (nonatomic, strong) HQEmployModel *employ;

@end
