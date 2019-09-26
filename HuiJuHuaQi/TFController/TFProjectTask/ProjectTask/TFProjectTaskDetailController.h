//
//  TFProjectTaskDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectTaskDetailController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** rowId */
@property (nonatomic, strong) NSNumber *rowId;

/** childRowId */
@property (nonatomic, strong) NSNumber *childRowId;

/** dataId */
@property (nonatomic, strong) NSNumber *dataId;
/** nodeCode */
@property (nonatomic, copy) NSString *nodeCode;

/** taskType 0:任务 1:子任务 2:个人任务 3:个人任务子任务 */
@property (nonatomic, assign) NSInteger taskType;

/** parentTaskId */
@property (nonatomic, strong) NSNumber *parentTaskId;

/** 主任务的截止时间 */
@property (nonatomic, strong) NSNumber *mainTaskEndTime;


/** 传值 */
@property (nonatomic, copy) ActionParameter action;

/** 删除 */
@property (nonatomic, copy) ActionHandler deleteAction;

/** 子任务操作 */
@property (nonatomic, copy) ActionHandler childAction;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refresh;

@end
