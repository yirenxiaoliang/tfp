//
//  TFApprovalCopyerController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFApprovalListItemModel.h"

@interface TFApprovalCopyerController : HQBaseViewController

/** dataId */
@property (nonatomic, strong) NSNumber *dataId;

/** employees */
@property (nonatomic, strong) NSArray *employees;

/** naviTitle */
@property (nonatomic, copy) NSString *naviTitle;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** TFApprovalListItemModel */
@property (nonatomic, strong) TFApprovalListItemModel *approvalItem;

@end
