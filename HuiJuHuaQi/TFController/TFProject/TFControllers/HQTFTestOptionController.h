//
//  HQTFTestOptionController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjTaskModel.h"
#import "TFProjectItem.h"

@interface HQTFTestOptionController : HQBaseViewController


/** isEdit */
@property (nonatomic, assign) BOOL isEdit;


/** subtask */
@property (nonatomic, strong) TFProjTaskModel *subtask;
/** taskDetail */
@property (nonatomic, strong) TFProjTaskModel *taskDetail;
/** TFProjectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;

/** 值 */
@property (nonatomic, copy) ActionHandler successAction;


@end
