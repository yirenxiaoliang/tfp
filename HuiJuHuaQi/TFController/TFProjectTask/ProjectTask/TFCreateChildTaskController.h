//
//  TFCreateChildTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCreateChildTaskController : HQBaseViewController

/** type 0:项目任务 1：个人任务 */
@property (nonatomic, assign) NSInteger type;
/** 父任务类型 1主任务，2子任务 */
@property (nonatomic, strong) NSNumber *parentTaskType;

/** taskId */
@property (nonatomic, strong) NSNumber *taskId;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** project_custom_id */
@property (nonatomic, strong) NSNumber *project_custom_id;
/** bean_name */
@property (nonatomic, copy) NSString *bean_name;

/** 主任务截止时间 */
@property (nonatomic, assign) long long taskEndTime;

/** employee */
@property (nonatomic, strong) HQEmployModel *employee;

/** refresh */
@property (nonatomic, copy) ActionHandler refreshAction;

@property (nonatomic, assign) BOOL present;

@end
