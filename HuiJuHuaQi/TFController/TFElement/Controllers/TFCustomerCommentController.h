//
//  TFCustomerCommentController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFApprovalListItemModel.h"

@interface TFCustomerCommentController : HQBaseViewController

/** id */
@property (nonatomic, strong) NSNumber *id;
/** processInstanceId */
//@property (nonatomic, copy) NSString *processInstanceId;

/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;

/** bean */
@property (nonatomic, copy) NSString *bean;

@property (nonatomic, copy) ActionParameter refreshAction;

@property (nonatomic, strong) NSNumber *style;

@end
