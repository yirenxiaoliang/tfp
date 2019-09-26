//
//  HQTFProjectPeopleManageController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjTaskModel.h"
#import "TFProjectItem.h"

@interface HQTFProjectPeopleManageController : HQBaseViewController


/** 项目、任务列表、任务id */
@property (nonatomic, strong) NSNumber *Id;

/** type 0:管理 1：选人 */
@property (nonatomic, assign) NSInteger type;

/** 选择的人员 */
@property (nonatomic, strong) NSArray *employees;
/** 是否多选 */
@property (nonatomic, assign) BOOL isMulti;

/** TFProjectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;

/** 值 */
@property (nonatomic, copy) ActionParameter peopleAction;

@end
