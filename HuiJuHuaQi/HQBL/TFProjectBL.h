//
//  TFProjectBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "TFProjectSectionModel.h"

@interface TFProjectBL : HQBaseBL

/** 创建项目 */
-(void)requestCreateProjectWithDict:(NSDictionary *)dict;
/** 创建项目分组 */
-(void)requestCreateProjectSectionWithModel:(TFProjectSectionModel *)model;
/** 创建项目分组任务列表 */
-(void)requestCreateProjectSectionTasksWithModel:(TFProjectRowModel *)model;
/** 创建任务(子任务) */
-(void)requestCreateTaskWithDict:(NSDictionary *)dict;
/** 项目列表 */
-(void)requestGetProjectListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize;
/** 项目详情 */
-(void)requestGetProjectDetailWithProjectId:(NSNumber *)projectId;
/** 任务列表 */
-(void)requestGetTaskListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize;
/** 任务详情 */
-(void)requestGetTaskDetailWithTaskId:(NSNumber *)taskId;



@end
