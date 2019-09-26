//
//  TFApprovalRejectController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFApprovalListItemModel.h"

@interface TFApprovalRejectController : HQBaseViewController

/** type 0:驳回到指定节点 1：需选择驳回方式 */
@property (nonatomic, assign) NSInteger type;

/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;
/** data */
@property (nonatomic, strong) NSDictionary *data;
@end
