//
//  HQTFCreatTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQTFCreatTaskModel.h"
#import "TFProjectSeeModel.h"

@interface HQTFCreatTaskController : HQBaseViewController

//@property (nonatomic, strong) HQTFCreatTaskModel *creatTask;
@property (nonatomic, strong) TFProjectSeeModel *projectSeeModel;

/** index : 任务列表index */
@property (nonatomic, assign) NSInteger index;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 项目的截止时间 */
@property (nonatomic, strong) NSNumber *projectEndTime;

@end
