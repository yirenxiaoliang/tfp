//
//  TFCooperationPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCooperationPeopleController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;
/** taskId */
@property (nonatomic, strong) NSNumber *taskId;
/** taskType */
@property (nonatomic, assign) NSInteger taskType;
/** parentTaskId */
@property (nonatomic, strong) NSNumber *parentTaskId;

/** parameterAction */
@property (nonatomic, copy) ActionParameter action;

/** 任务权限 */
@property (nonatomic, strong) NSArray *taskRoleAuths;
/** 角色 */
@property (nonatomic, copy) NSString *role;
/** 项目状态 */
@property (nonatomic, copy) NSString *project_status;
/** 任务状态 */
@property (nonatomic, copy) NSString *complete_status;

@end
