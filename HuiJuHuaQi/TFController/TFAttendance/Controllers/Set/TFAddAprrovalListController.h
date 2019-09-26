//
//  TFAddAprrovalListController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFReferenceApprovalModel.h"

@interface TFAddAprrovalListController : HQBaseViewController

@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong) TFReferenceApprovalModel *model;

@property (nonatomic, copy) ActionHandler refreshAction;

@end
