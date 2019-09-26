//
//  TFAddTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceFieldModel.h"
#import "HQEmployModel.h"


@interface TFAddTaskController : HQBaseViewController

/** type 0:新增 1:详情 2：编辑 3：复制 7：重新编辑(含：发起人撤销、驳回到发起人) 8:项目任务布局 9:个人任务布局 */
@property (nonatomic, assign) NSInteger type;
/** 用于项目任务和个人任务编辑区别 1：项目任务 2：项目子任务 3：个人任务 4：个人子任务 */
@property (nonatomic, assign) NSInteger edit;

/** bean */
@property (nonatomic, copy) NSString *bean;
/** taskKey */
@property (nonatomic, copy) NSString *taskKey;
/** isSeasPool 是否为公海池 0：非 1：是 */
@property (nonatomic, copy) NSString *isSeasPool;
/** 公海池id */
@property (nonatomic, strong) NSNumber *seaPoolId;
/** processFieldV */
@property (nonatomic, strong) NSNumber *processFieldV;

/** id */
@property (nonatomic, strong) NSNumber *dataId;

/** height */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 导航栏透明 */
@property (nonatomic, assign) BOOL translucent;


/** 关联数组 */
@property (nonatomic, strong) NSArray <TFRelevanceFieldModel *>*relevances;

/** HQEmployModel *emp */
@property (nonatomic, strong) HQEmployModel *employ;

/** 用于父控制器刷新 */
@property (nonatomic, copy) ActionHandler fatherRefresh;

/** 邮箱回调 */
@property (nonatomic, copy) ActionParameter emailBlock;

/** 详情回调 */
@property (nonatomic, copy) ActionParameter detailBlock;

/** lastDetailDict */
@property (nonatomic, strong) NSDictionary *lastDetailDict;
/** relevanceKey */
@property (nonatomic, copy) NSString *relevanceKey;

/** projectId:项目id */
@property (nonatomic, strong) NSNumber *projectId;
/** rowId:任务列id */
@property (nonatomic, strong) NSNumber *rowId;
/** taskId:任务id */
@property (nonatomic, strong) NSNumber *taskId;
/** parentTaskId:父任务id */
@property (nonatomic, strong) NSNumber *parentTaskId;

/** 新建后传值 */
@property (nonatomic, copy) ActionParameter parameterAction;

/** 修改截止时间是否需要填写修改原因 */
@property (nonatomic, copy) NSString <Optional>*project_time_status;
/** 主任务截止时间 */
@property (nonatomic, strong) NSNumber *mainTaskEndTime;

@end
