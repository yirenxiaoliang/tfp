//
//  TFProjectTaskBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "TFProjectShareSendModel.h"
#import "TFProjectSectionModel.h"
#import "TFProjectShareRelatedModel.h"

@interface TFProjectTaskBL : HQBaseBL


/** 创建项目 */
-(void)requestCreateProjectWithDict:(NSDictionary *)dict;
/** 设置项目 */
-(void)requestUpdateProjectDetailWithDict:(NSDictionary *)dict;
/** 项目列表 */
-(void)requestGetProjectListWithType:(NSInteger)type PageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize keyword:(NSString *)keyword;
/** 项目详情 */
-(void)requestGetProjectDetailWithProjectId:(NSNumber *)projectId;
/** 项目状态变更 */
-(void)requestChangeProjectStatusWithProjectId:(NSNumber *)projectId status:(NSNumber *)status;
/** 项目成员列表 */
-(void)requsetGetProjectPeopleWithProjectId:(NSNumber *)projectId;
/** 删除项目成员 */
-(void)requsetDeleteProjectPeopleWithRecordId:(NSNumber *)recordId recipient:(NSNumber *)recipient;
/** 新增项目成员 */
-(void)requsetAddProjectPeopleWithProjectId:(NSNumber *)projectId peoplesIds:(NSString *)peoplesIds;
/** 获取项目管理角色列表 */
-(void)requsetGetProjectRoleListWithProjectId:(NSNumber *)projectId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;
/** 修改项目角色 */
-(void)requsetUpdateProjectRoleWtihRecordId:(NSNumber *)recordId projectRole:(NSNumber *)projectRole projectTaskRole:(NSNumber *)projectTaskRole;
/** 获取项目标签 */
-(void)requsetGetProjectLabelWithProjectId:(NSNumber *)projectId keyword:(NSString *)keyword type:(NSInteger)type;
/** 获取个人标签 */
-(void)requsetGetPersonnelLabelWithType:(NSInteger)type;
/** 获取标签库所有标签 */
-(void)requsetGetLabelRepositoryWithProjectId:(NSNumber *)projectId keyword:(NSString *)keyword  type:(NSInteger)type;
/** 项目增添or删除标签 */
-(void)requsetAddProjectLabelWithProjectId:(NSNumber *)projectId ids:(NSString *)ids;
/** 更新项目星标 */
-(void)requsetUpdateProjectStarWithProjectId:(NSNumber *)projectId starLevel:(NSNumber *)starLevel;
/** 更新项目进度 */
-(void)requsetUpdateProjectProgressWithProjectId:(NSNumber *)projectId projectProgressStatus:(NSNumber *)projectProgressStatus projectProgressContent:(NSNumber *)projectProgressContent;


/** 创建任务分组 */
-(void)requestCreateProjectSectionWithModel:(TFProjectRowModel *)model;
/** 任务分组重命名 */
-(void)requestUpdateProjectSectionWithModel:(TFProjectRowModel *)model;
/** 删除任务分组 */
-(void)requestDeleteProjectColumnWithColumnId:(NSNumber *)columnId projectId:(NSNumber *)projectId;
/** 获取任务分组 */
-(void)requestGetProjectColumnWithProjectId:(NSNumber *)projectId;


/** 创建项目分组任务列表 */
-(void)requestCreateProjectSectionTasksWithModel:(TFProjectRowModel *)model;
/** 项目分组任务列表重命名 */
-(void)requestUpdateProjectSectionTasksWithModel:(TFProjectRowModel *)model;
/** 获取任务列 */
-(void)requestGetProjectSectionWithColumnId:(NSNumber *)columnId;
/** 删除任务列 */
-(void)requestDeleteProjectSectionWithSectionId:(NSNumber *)sectionId columnId:(NSNumber *)columnId projectId:(NSNumber *)projectId;


/** 获取项目所有节点 */
-(void)requestGetProjectAllDotWithProjectId:(NSNumber *)projectId;


/** 任务分组拖拽排序 */
-(void)requestSortProjectColumnWithList:(NSArray *)list projectId:(NSNumber *)projectId;
/** 任务列拖拽排序 */
-(void)requestSortProjectSectionWithList:(NSArray *)list columnId:(NSNumber *)columnId projectId:(NSNumber *)projectId activeNodeId:(NSNumber *)activeNodeId originalNodeId:(NSNumber *)originalNodeId;
/** 任务列添加引用 项目id，任务列id，引用的模块bean，引用的数据id */
-(void)requestAddQuoteWithDict:(NSDictionary *)dict;

/** 获取某任务列表任务 */
-(void)requsetGetTaskWithSectionId:(NSNumber *)sectionId pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize rowIndex:(NSInteger)rowIndex filterParam:(NSDictionary *)filterParam;
/** 创建任务 */
-(void)requestCreateTaskWithDict:(NSDictionary *)dict;
/** 创建项目任务子任务 */
-(void)requestCreateChildTaskWithDict:(NSDictionary *)dict;
/** 任务详情 */
-(void)requestGetTaskDetailWithTaskId:(NSNumber *)taskId;
/** 子任务详情 */
-(void)requestGetChildTaskDetailWithChildTaskId:(NSNumber *)childTaskId;
/** 获取任务的子任务 */
-(void)requestGetChildTaskListWithTaskId:(NSNumber *)taskId nodeCode:(NSString *)nodeCode;
/** 获取个人任务的子任务 */
-(void)requestGetPersonnelChildTaskListWithTaskId:(NSNumber *)taskId;
/** 获取任务关联列表
 *@prama taskId 任务ID or 子任务ID
 *@prama taskType 任务关联 1,子任务关联2
 */
-(void)requestGetTaskRelationListWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType;
/** 获取任务被关联列表
 *@prama taskId 任务ID
 */
-(void)requestGetTaskRelatedListWithTaskId:(NSNumber *)taskId;
/** 新增任务关联 */
-(void)requestAddTaskRelationWithDict:(NSDictionary *)dict;
/** 引用任务关联 */
-(void)requestQuoteTaskRelationWithDict:(NSDictionary *)dict;
/** 取消任务关联 */
-(void)requestCancelTaskRelationWithDataId:(NSNumber *)dataId;
/** 取消个人任务关联 */
-(void)requestCancelPersonnelTaskRelationWithDataId:(NSNumber *)dataId fromType:(NSNumber *)fromType taskId:(NSNumber *)taskId;
/** 任务拖拽排序
 @prama originalNodeId 原来分列id
 @prama toSubnodeId 目标子节点记录ID
 @prama dataList 任务id对象数组
 @prama moveId 移动任务id
 */
-(void)requestDragTaskToSortWithOriginalNodeId:(NSNumber *)originalNodeId toSubnodeId:(NSNumber *)toSubnodeId dataList:(NSArray *)dataList moveId:(NSNumber *)moveId;
/** 任务完成及激活 */
-(void)requestTaskFinishOrActiveWithTaskId:(NSNumber *)taskId completeStatus:(NSNumber *)completeStatus remark:(NSString *)remark;
/** 子任务完成及激活 */
-(void)requestChildTaskFinishOrActiveWithTaskId:(NSNumber *)taskId completeStatus:(NSNumber *)completeStatus remark:(NSString *)remark;
/** 个人任务完成及激活 */
-(void)requestPersonnelTaskFinishOrActiveWithTaskId:(NSNumber *)taskId;
/** 任务or子任务点赞或取消点赞
 *@param taskId （分享，任务，子任务）记录id
 *@param status  0不点赞  1点赞
 *@param typeStatus 点赞类型，0 分享，1任务，2子任务
 */
-(void)requestTaskHeartWithTaskId:(NSNumber *)taskId status:(NSNumber *)status typeStatus:(NSNumber *)typeStatus;
/** 个人任务or子任务点赞或取消点赞 */
-(void)requestPersonnelTaskHeartWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType status:(NSNumber *)status;
/** 点赞人员列表
 *@param taskId 任务（子任务）ID
 *@param typeStatus 点赞类型，0 分享，1任务，2子任务
 */
-(void)requestTaskHeartPeopleWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus;
/** 个人任务点赞人员列表 */
-(void)requestPersonnelTaskHeartPeopleWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType;
/** 任务层级 */
-(void)requsetTaskHierarchyWithTaskId:(NSNumber *)taskId;
/** 修改项目任务可见性 */
-(void)requsetTaskVisibleWithTaskId:(NSNumber *)taskId associatesStatus:(NSNumber *)associatesStatus taskType:(NSNumber *)taskType;
/** 修改个人任务可见性 */
-(void)requsetPersonnelTaskVisibleWithTaskId:(NSNumber *)taskId participantsOnly:(NSNumber *)participantsOnly fromType:(NSNumber *)fromType;
/** 校验任务
 *@prama taskId  任务id
 *@prama check  0待检验 1通过 2驳回
 *@prama content  备注
 */
-(void)requestTaskCheckWithTaskId:(NSNumber *)taskId status:(NSNumber *)status content:(NSString *)content;
/** 校验子任务
 *@prama taskId  子任务id
 *@prama check  0待检验 1通过 2驳回
 *@prama content  备注
 */
-(void)requestChildTaskCheckWithTaskId:(NSNumber *)taskId status:(NSNumber *)status content:(NSString *)content;
/** 移动任务到某列 */
-(void)requestMoveTaskToNewNodeCode:(NSString *)newNodeCode nodeCode:(NSString *)nodeCode taskId:(NSNumber *)taskId;
/** 复制任务到某列 */
-(void)requestCopyTaskToNewNodeCode:(NSString *)newNodeCode nodeCode:(NSString *)nodeCode taskId:(NSNumber *)taskId;
/** 删除任务 */
-(void)requestDeleteTaskWithTaskId:(NSNumber *)taskId;
/** 删除子任务 */
-(void)requestDeleteChildTaskWithTaskChildId:(NSNumber *)taskChildId;
/** 任务列表（用于引用选择任务） */
-(void)requestGetQuoteTaskListWithKeyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize projectId:(NSNumber *)projectId from:(NSNumber *)from;
/** 任务筛选自定义条件接口 */
-(void)requestGetProjectTaskFilterConditionWithProjectId:(NSNumber *)projectId;
/** 任务筛选 */
-(void)requestProjectTaskFilterWithDict:(NSDictionary *)dict;
/** 个人任务筛选 */
-(void)requestPersonnelTaskFilterWithQueryType:(NSInteger)type queryWhere:(NSDictionary *)queryWhere sortField:(NSArray *)sortField dateFormat:(NSNumber *)dateFormat;
/** 个人任务详情 */
-(void)requestPersonnelTaskDetailWithTaskId:(NSNumber *)taskId;
/** 个人任务子任务详情 */
-(void)requestPersonnelSubTaskDetailWithTaskId:(NSNumber *)taskId;
/** 某项目下的任务 */
-(void)requestTaskInProjectWithProjectId:(NSNumber *)projectId queryType:(NSNumber *)queryType;
/** 获取项目任务协作人列表 */
-(void)requestGetProjectTaskCooperationPeopleListWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus;
/** 获取项目任务角色 */
-(void)requestGetProjectTaskRoleWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus;
/** 获取个人任务协作人列表 */
-(void)requestGetPersonnelTaskCooperationPeopleListWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus;
/** 获取个人任务角色 */
-(void)requestGetPersonnelTaskRoleWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus;
/** add项目任务协作人 */
-(void)requestAddProjectTaskCooperationPeopleWithDict:(NSDictionary *)dict;
/** add个人任务协作人*/
-(void)requestAddPersonnelTaskCooperationPeopleListWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus employeeIds:(NSString *)employeeIds;
/** 删除个人任务协作人 */
-(void)requestDeletePersonnelTaskCooperationPeopleWithFromType:(NSNumber *)fromType taskId:(NSNumber *)taskId employeeIds:(NSString *)employeeIds;
/** 删除项目任务协作人*/
-(void)requestDeleteProjectTaskCooperationPeopleWithRecordId:(NSNumber *)recordId;
/** 创建个人任务子任务 */
-(void)requestCreatePersonnelChildTaskWithDict:(NSDictionary *)dict;
/** 个人任务引用个人任务 */
-(void)requestPersonnelTaskQuotePersonnelTaskWithDict:(NSDictionary *)dict;
/** 个人任务关联 */
-(void)requestPersonnelTaskRelationListWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType;
/** 个人任务被关联 */
-(void)requestPersonnelTaskByRelatedListWithTaskId:(NSNumber *)taskId;
/** 编辑个人任务 */
-(void)requestEditPersonnelTaskWithDict:(NSDictionary *)dict;
/** 编辑个人子任务 */
-(void)requestEditPersonnelSubTaskWithDict:(NSDictionary *)dict;
/** 编辑项目任务 */
-(void)requestEditProjectTaskWithDict:(NSDictionary *)dict;
/** 个人任务删除 */
-(void)requsetPersonnelTaskDeleteWithTaskIds:(NSString *)taskIds;
/** 个人任务子任务删除 */
-(void)requsetPersonnelSubTaskDeleteWithTaskIds:(NSString *)taskIds;
/** 获取项目任务提醒 */
-(void)requestGetTaskRemainWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType;
/** 设置项目任务提醒 */
-(void)requsetSettingTaskRemainWithDict:(NSDictionary *)dict;
/** 更新项目任务提醒 */
-(void)requsetUpdateTaskRemainWithDict:(NSDictionary *)dict;
/** 获取所有项目 */
-(void)requsetAllProjectWithKeyword:(NSString *)keyword type:(NSInteger)type;
/** 获取个人任务列表 */
-(void)requestGetPersonnelTaskListWithKeyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;
/** 获取工作流列表 */
-(void)requsetGetProjectWorkflow;
/** 工作流预览 */
-(void)requsetProjectWorkflowPreviewWithWorkflowId:(NSNumber *)workflowId;
/** 获取个人任务筛选条件 */
-(void)requsetGetPersonnelTaskFilterCondition;
/** 获取个人权限下的所有自定义模块 */
-(void)requestGetMyselfCustomModule;
/** 获取工作台列表 */
-(void)requestGetWorkBenchList;
/** 获取时间工作流数据 workBenchType 1:超期未完成 2:今日要做 3:明天要做 4:以后要做 */
-(void)requestGetWorkBenchDataWithWorkBenchType:(NSNumber *)workBenchType index:(NSInteger)index pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;
/** 获取时间工作流数据 workBenchType 1:超期未完成 2:今日要做 3:明天要做 4:以后要做 */
-(void)requestGetWorkBenchDataWithWorkBenchType:(NSNumber *)workBenchType index:(NSInteger)index pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize memeberIds:(NSString *)memeberIds;
/** 企业工作台流程列表 */
-(void)requestEnterpriseWorkBenchFlow;
/** 获取企业工作流数据 */
-(void)requestGetEnterpriseWorkBenchDataWithFlowId:(NSString *)flowId index:(NSInteger)index;
/** 时间工作台移动 */
-(void)requestTimeWorkBenchMoveWithTimeId:(NSNumber *)timeId workbenchTag:(NSNumber *)workbenchTag dataList:(NSArray *)dataList;
/** 企业工作台移动 */
-(void)requestEnterpriseWorkBenchMoveWithTaskId:(NSNumber *)taskId flowId:(NSString *)flowId;
/** 项目模板 or 个人模板 */
-(void)requestGetProjectModelWithTemplateRole:(NSNumber *)templateRole templateType:(NSNumber *)templateType;
/** 项目模板预览 */
-(void)requestGetProjectTemplatePreviewWithTemplateId:(NSNumber *)templateId;
/** 获取某人在某项目的角色及权限 */
-(void)requestGetProjectRoleAndAuthWithProjectId:(NSNumber *)projectId employeeId:(NSNumber *)employeeId;
/** 角色项目任务权限 */
-(void)requestGetRoleProjectTaskAuthWithProjectId:(NSNumber *)projectId;
/** 项目任务查看状态 */
-(void)requsetGetProjectTaskSeeStatusWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId taskType:(NSNumber *)taskType;
/** 个人任务查看状态 */
-(void)requsetGetPersonnelTaskSeeStatusWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType;
/** 保存项目任务设置重复 */
-(void)requsetSaveProjectTaskRepeatWithDict:(NSDictionary *)dict;
/** 更新项目任务设置重复 */
-(void)requsetUpdateProjectTaskRepeatWithDict:(NSDictionary *)dict;
/** 获取项目任务设置重复 */
-(void)requsetGetProjectTaskRepeatWithTaskId:(NSNumber *)taskId;
/** 获取个人任务提醒 */
-(void)requsetGetPersonnelTaskRemindWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType;
/** 保存个人任务提醒 */
-(void)requsetSavePersonnelTaskRemindWithDict:(NSDictionary *)dict;
/** 更新个人任务提醒 */
-(void)requsetUpdatePersonnelTaskRemindWithDict:(NSDictionary *)dict;
/** 保存个人任务设置重复 */
-(void)requsetSavePersonnelTaskRepeatWithDict:(NSDictionary *)dict;
/** 更新个人任务设置重复 */
-(void)requsetUpdatePersonnelTaskRepeatWithDict:(NSDictionary *)dict;
/** 获取个人任务设置重复 */
-(void)requsetGetPersonnelTaskRepeatWithTaskId:(NSNumber *)taskId;
/** 编辑项目任务 */
-(void)requestUpdateProjectTaskWithDict:(NSDictionary *)dict;
/** 编辑项目子任务 */
-(void)requestUpdateProjectChildTaskWithDict:(NSDictionary *)dict;
/** 获取项目任务的完成权限及填写激活原因 taskType:1主任务，2子任务 */
-(void)requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId taskType:(NSNumber *)taskType;
/** 移出成员是否需要指定工作交接人 */
-(void)requsetDeleteProjectPeopleTransferTaskWithProjectMemberId:(NSNumber *)projectMemberId;
/** 层级视图取消关联数据 */
-(void)requestBoardDataCancelRelationshipWithIds:(NSString *)ids;

#pragma mark 项目分享
/** 新增分享 */
- (void)requestProjectShareControllerSaveWithModel:(TFProjectShareSendModel *)model;

/** 修改分享 */
- (void)requestProjectShareControllerEditWithModel:(TFProjectShareSendModel *)model;

/** 删除分享 */
- (void)requestProjectShareControllerDeleteWithId:(NSNumber *)shareId;

/** 关联变更 */
- (void)requestProjectShareControllerEditRelevanceWithId:(NSNumber *)shareId itemsArr:(NSArray *)itemsArr;

/** 分享置顶 */
- (void)requestProjectShareControllerShareStickWithId:(NSNumber *)shareId status:(NSNumber *)status;

/** 分享点赞 */
- (void)requestProjectShareControllerSharePraiseWithId:(NSNumber *)shareId status:(NSNumber *)status;

/** 分享详情 */
- (void)requestProjectShareControllerQueryByIdWithId:(NSNumber *)shareId;

/** 分享列表   type:  0所有分享   1我的分享 */
- (void)requestProjectShareControllerQueryListWithData:(NSNumber * )pageNum pageSize:(NSNumber * )pageSize keyword:(NSString *)keyword type:(NSNumber * )type projectId:(NSNumber *)projectId;

/** 获取关联内容 */
- (void)requestProjectShareControllerQueryRelationListWithData:(NSNumber * )shareId;

/** 分享关联内容 */
- (void)requestProjectShareControllerSaveRelationWithModel:(TFProjectShareRelatedModel *)model;

/** 取消关联内容 */
- (void)requestProjectShareControllerCancleRelationWithId:(NSString *)shareId;

#pragma mark 项目文库
/** 项目文库列表 */
- (void)requestProjectLibraryQueryLibraryListWithId:(NSNumber *)fileId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 文库任务列表 */
- (void)requestprojectLibraryQueryFileLibraryListWithId:(NSNumber *)dataId type:(NSString *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 文库列表 */
- (void)requestprojectLibraryQueryTaskLibraryListWithId:(NSNumber *)dataId type:(NSString *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord;

/** 文库根搜索列表 */
- (void)requestprojectLibrarySearchWithProjectId:(NSNumber *)projectId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord;

/** 添加文库文件夹 */
- (void)requestProjectLibrarySavaLibraryWithData:(NSString *)fileName projectId:(NSNumber *)projectId parentId:(NSNumber *)parentId type:(NSNumber *)type;

/** 修改文库文件夹 */
- (void)requestProjectLibraryEditLibraryWithData:(NSString *)fileName fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId;

/** 删除文库文件夹 */
- (void)requestProjectLibraryDelLibraryWithData:(NSString *)fileName fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId;

/** 共享文件夹 */
- (void)requestProjectLibrarySavaLibraryWithData:(NSNumber *)fileId employeeId:(NSNumber *)employeeId;

/** 上传文件 */
- (void)requestCommonFileProjectUploadWithData:(NSNumber *)fileId projectId:(NSNumber *)projectId images:(NSArray *)images;

/** 下载文件 */
- (void)requestCommonFileProjectDownloadWithData:(NSNumber *)fileId;

/** 文件下载记录 */
- (void)requestFileProjectDownloadRecordWithFileId:(NSNumber *)fileId;


/** 工作台切换成员权限 */
- (void)requestWorkBenchChangePeopleAuth;

/** 工作台切换人员列表 */
-(void)requestChangePeopleList;


/****************新版协作接口****************/
/** 获取所有节点 */
-(void)requestAllNodeWithProjectId:(NSNumber *)projectId limitNodeType:(NSNumber *)limitNodeType filterParam:(NSDictionary *)filterParam;
/** 获取模板节点 */
-(void)requestTemplateWithTempId:(NSNumber *)tempId;
/** 新增节点 */
-(void)requestAddNodeWithDict:(NSDictionary *)dict;
/** 更新节点 */
-(void)requestUpdateNodeWithDict:(NSDictionary *)dict;
/** 删除节点 */
-(void)requestDeleteNodeWithDict:(NSDictionary *)dict;
/** 新增任务 */
-(void)requestAddTaskWithDict:(NSDictionary *)dict;
/** 编辑任务 */
-(void)requestUpdateTaskWithDict:(NSDictionary *)dict;
/** 新增子任务 */
-(void)requestAddSubTaskWithDict:(NSDictionary *)dict;
/** 编辑子任务 */
-(void)requestUpdateSubTaskWithDict:(NSDictionary *)dict;
/** 复制任务 */
-(void)requestCopyTaskWithDict:(NSDictionary *)dict;
/** 移动任务 */
-(void)requestMoveTaskWithDict:(NSDictionary *)dict;
/** 子任务列表 */
-(void)requestGetSubTaskWithSubTaskId:(NSNumber *)subTaskId parentNodeCode:(NSNumber *)parentNodeCode;

/** 任务混合动态
 * @prama taskId 任务编号
 * @prama taskType 1:主任务，2子任务
 * @prama dynamicType 0：全部，1评论，2查看状态，3操作日志
 * @prama pageSize 获取数量
 */
-(void)requestTaskHybirdDynamicWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType dynamicType:(NSNumber *)dynamicType pageSize:(NSNumber *)pageSize;

/** 个人任务列表 */
-(void)requestNewPersonnelTaskListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize queryWhere:(NSDictionary *)queryWhere sortField:(NSString *)sortField dateFormat:(NSNumber *)dateFormat queryType:(NSNumber *)queryType;

/** 项目任务列表 */
-(void)requestNewProjectTaskListWithProjectId:(NSNumber *)projectId PageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize queryWhere:(NSDictionary *)queryWhere sortField:(NSString *)sortField dateFormat:(NSNumber *)dateFormat queryType:(NSNumber *)queryType bean:(NSString *)bean;

@end
