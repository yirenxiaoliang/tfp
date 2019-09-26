//
//  TFCreateProjectController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFCreateProjectController : HQBaseViewController

/** type 0:新建 1：详情 2：编辑 */
@property (nonatomic, assign) NSInteger type;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** refreshAction */
@property (nonatomic, copy) ActionParameter refreshAction;

/** progressAction */
@property (nonatomic, copy) ActionParameter progressAction;

/** deleteAction */
@property (nonatomic, copy) ActionHandler deleteAction;

/** 用于记录校验 */
@property (nonatomic, strong) TFProjectModel *projectModel;

@end
