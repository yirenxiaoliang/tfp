//
//  HQTFAddPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectItem.h"

@interface HQTFAddPeopleController : HQBaseViewController

/** 多选 */
@property (nonatomic, assign) BOOL isMutual;


/** 项目、任务列表、任务id */
@property (nonatomic, strong) NSNumber *Id;
/** TFProjectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;


/** type */
@property (nonatomic, assign) ChoicePeopleType type;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

/** 选择的人员 */
@property (nonatomic, strong) NSArray *employees;

@end
