//
//  TFProjectMenberManageController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectMenberManageController : HQBaseViewController

@property (nonatomic, strong) TFProjectModel *projectModel;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** type 0:管理 1：选择 */
@property (nonatomic, assign) NSInteger type;

/** isMulti */
@property (nonatomic, assign) BOOL isMulti;


/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;


/** selectPeoples */
@property (nonatomic, strong) NSArray *selectPeoples;

@property (nonatomic, assign) BOOL isTransfer;


@end
