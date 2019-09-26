//
//  HQTFLabelManageController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectItem.h"

typedef enum {
    LabelManageControllerManage,
    LabelManageControllerSelect
}LabelManageControllerType;

@interface HQTFLabelManageController : HQBaseViewController

/** 类型 0:管理 1：选择 */
@property (nonatomic, assign) LabelManageControllerType type;

/** 值 */
@property (nonatomic, copy) ActionParameter labelAction;

/** project */
@property (nonatomic, strong) NSNumber *projectId;

/** selectLabels */
@property (nonatomic, strong) NSMutableArray *didSelectLabels;

/** TFProjectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;


@end
