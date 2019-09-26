//
//  TFApprovalPassController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFApprovalListItemModel.h"

@interface TFApprovalPassController : HQBaseViewController

/** type 0:固定流程有人 1：固定流程无人（指定角色） 2：自由流程 3:转交 4:催办 */
@property (nonatomic, assign) NSInteger type;

/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

/** data */
@property (nonatomic, strong) NSDictionary *data;

/** 或签，会签人员id数组 */
@property (nonatomic, strong) NSArray *currentNodeUsers;

/** oldData */
@property (nonatomic, strong) NSDictionary *oldData;

/** data */
@property (nonatomic, strong) NSDictionary *layout_data;


@end
