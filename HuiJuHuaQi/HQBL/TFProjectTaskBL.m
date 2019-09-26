//
//  TFProjectTaskBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectTaskBL.h"
#import "TFProjectShareMainModel.h"
#import "TFProjectShareInfoModel.h"
#import "TFProjectListModel.h"
#import "TFProjectColumnModel.h"
#import "TFProjectModel.h"
#import "TFProjectPeopleModel.h"
#import "TFProjectLabelModel.h"
#import "TFChangeHelper.h"
#import "TFProjectFileMainModel.h"
#import "TFProjectFileSubModel.h"
#import "TFQuoteTaskListModel.h"
#import "TFDownloadRecordModel.h"
#import "TFTaskHybirdDynamicModel.h"

@implementation TFProjectTaskBL


/** 创建项目 */
-(void)requestCreateProjectWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_createProject];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createProject
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 项目详情 */
-(void)requestGetProjectDetailWithProjectId:(NSNumber *)projectId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjecDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjecDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 项目列表 */
-(void)requestGetProjectListWithType:(NSInteger)type PageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize keyword:(NSString *)keyword{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(type) forKey:@"type"];
    
    if (pageNo) {
        [dict setObject:pageNo forKey:@"pageNum"];
    }
    
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (keyword && ![keyword isEqualToString:@""]) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 设置项目详情 */
-(void)requestUpdateProjectDetailWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_updateProject];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProject
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 项目状态变更 */
-(void)requestChangeProjectStatusWithProjectId:(NSNumber *)projectId status:(NSNumber *)status{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_changeProjectStatus];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_changeProjectStatus
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}


/** 项目成员列表 */
-(void)requsetGetProjectPeopleWithProjectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 删除项目成员 */
-(void)requsetDeleteProjectPeopleWithRecordId:(NSNumber *)recordId recipient:(NSNumber *)recipient{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (recordId) {
        [dict setObject:recordId forKey:@"id"];
    }
    if (recipient) {
        [dict setObject:recipient forKey:@"recipient"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteProjectPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteProjectPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 新增项目成员 */
-(void)requsetAddProjectPeopleWithProjectId:(NSNumber *)projectId peoplesIds:(NSString *)peoplesIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    
    if (peoplesIds) {
        [dict setObject:peoplesIds forKey:@"employeeIds"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_addProjectPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addProjectPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取项目管理角色列表 */
-(void)requsetGetProjectRoleListWithProjectId:(NSNumber *)projectId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectRoleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectRoleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 修改项目角色 */
-(void)requsetUpdateProjectRoleWtihRecordId:(NSNumber *)recordId projectRole:(NSNumber *)projectRole projectTaskRole:(NSNumber *)projectTaskRole{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (recordId) {
        [dict setObject:recordId forKey:@"id"];
    }
    if (projectRole) {
        [dict setObject:projectRole forKey:@"projectRole"];
    }
    if (projectTaskRole) {
        [dict setObject:projectTaskRole forKey:@"projectTaskRole"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectRole];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectRole
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取项目标签 */
-(void)requsetGetProjectLabelWithProjectId:(NSNumber *)projectId keyword:(NSString *)keyword  type:(NSInteger)type{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    [dict setObject:@(type) forKey:@"type"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取个人标签 */
-(void)requsetGetPersonnelLabelWithType:(NSInteger)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(type) forKey:@"type"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取标签库所有标签 */
-(void)requsetGetLabelRepositoryWithProjectId:(NSNumber *)projectId keyword:(NSString *)keyword  type:(NSInteger)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    [dict setObject:@(type) forKey:@"type"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_repositoryLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_repositoryLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 项目增添标签 */
-(void)requsetAddProjectLabelWithProjectId:(NSNumber *)projectId ids:(NSString *)ids{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (ids) {
        [dict setObject:ids forKey:@"ids"];
    }
    NSString *url = [super urlFromCmd:HQCMD_addProjectLabel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addProjectLabel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 更新项目星标 */
-(void)requsetUpdateProjectStarWithProjectId:(NSNumber *)projectId starLevel:(NSNumber *)starLevel{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (starLevel) {
        [dict setObject:starLevel forKey:@"star_level"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectStar];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectStar
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 更新项目进度 */
-(void)requsetUpdateProjectProgressWithProjectId:(NSNumber *)projectId projectProgressStatus:(NSNumber *)projectProgressStatus projectProgressContent:(NSNumber *)projectProgressContent{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    if (projectProgressStatus) {
        [dict setObject:projectProgressStatus forKey:@"project_progress_status"];
    }
    if (projectProgressContent) {
        [dict setObject:projectProgressContent forKey:@"project_progress_content"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectProgress];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectProgress
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 创建项目分组 */
-(void)requestCreateProjectSectionWithModel:(TFProjectRowModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"id"];
    }
    
    if (model.name) {
        [dict setObject:model.name forKey:@"name"];
    }
    
    if (model.names && model.names.count) {
        
        [dict setObject:model.names forKey:@"subnodeArr"];
        
        if (model.name) {
            [dict setObject:model.name forKey:@"name"];
        }
        
        if (model.flowId) {
            [dict setObject:model.flowId forKey:@"flowId"];
        }
        if (model.flowStatus) {
            [dict setObject:model.flowStatus forKey:@"flowStatus"];
        }
    }
    
    NSString *url = [super urlFromCmd:HQCMD_createProjectSection];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createProjectSection
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 项目分组重命名 */
-(void)requestUpdateProjectSectionWithModel:(TFProjectRowModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"projectId"];
    }
    
    if (model.id) {
        [dict setObject:model.id forKey:@"nodeId"];
    }
    
    if (model.name) {
        [dict setObject:model.name forKey:@"name"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectSection];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectSection
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 创建项目分组任务列表 */
-(void)requestCreateProjectSectionTasksWithModel:(TFProjectRowModel *)model{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"projectId"];
    }
    
    if (model.sectionId) {
        [dict setObject:model.sectionId forKey:@"nodeId"];
    }
    
//    if (model.names && model.names.count) {
//
//        [dict setObject:model.names forKey:@"subnodeArr"];
//
//        if (model.name) {
//            [dict setObject:model.name forKey:@"name"];
//        }
//
//        if (model.flowId) {
//            [dict setObject:model.flowId forKey:@"flowId"];
//        }
//        if (model.flowStatus) {
//            [dict setObject:model.flowStatus forKey:@"flowStatus"];
//        }
//    }
    
    
    if (model.names.count == 0 && model.name) {
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *di = [NSDictionary dictionaryWithObject:model.name forKey:@"name"];
        [arr addObject:di];
        [dict setObject:arr forKey:@"subnodeArr"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_createProjectSectionRows];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createProjectSectionRows
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 项目分组任务列表重命名 */
-(void)requestUpdateProjectSectionTasksWithModel:(TFProjectRowModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"projectId"];
    }
    
    if (model.sectionId) {
        [dict setObject:model.sectionId forKey:@"nodeId"];
    }
    
    if (model.id) {
        [dict setObject:model.id forKey:@"subnodeId"];
    }
    
    if (model.name) {
        [dict setObject:model.name forKey:@"name"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectSectionRows];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectSectionRows
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取项目所有节点 */
-(void)requestGetProjectAllDotWithProjectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectAllDot];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectAllDot
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取项目分组 */
-(void)requestGetProjectColumnWithProjectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectColumn];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectColumn
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取任务列 */
-(void)requestGetProjectSectionWithColumnId:(NSNumber *)columnId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (columnId) {
        [dict setObject:columnId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectSection];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectSection
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除任务分组 */
-(void)requestDeleteProjectColumnWithColumnId:(NSNumber *)columnId projectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (columnId) {
        [dict setObject:columnId forKey:@"nodeId"];
    }
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteProjectColumn];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteProjectColumn
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 删除任务列 */
-(void)requestDeleteProjectSectionWithSectionId:(NSNumber *)sectionId columnId:(NSNumber *)columnId projectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (columnId) {
        [dict setObject:columnId forKey:@"nodeId"];
    }
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (sectionId) {
        [dict setObject:sectionId forKey:@"subnodeId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_deleteProjectSection];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteProjectSection
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 任务分组拖拽排序 */
-(void)requestSortProjectColumnWithList:(NSArray *)list projectId:(NSNumber *)projectId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (list) {
        [dict setObject:list forKey:@"dataList"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_sortProjectColumn];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_sortProjectColumn
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 任务列拖拽排序 */
-(void)requestSortProjectSectionWithList:(NSArray *)list columnId:(NSNumber *)columnId projectId:(NSNumber *)projectId activeNodeId:(NSNumber *)activeNodeId originalNodeId:(NSNumber *)originalNodeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (columnId) {
        [dict setObject:columnId forKey:@"toNodeId"];
    }
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (activeNodeId) {
        [dict setObject:activeNodeId forKey:@"activeNodeId"];
    }
    if (originalNodeId) {
        [dict setObject:originalNodeId forKey:@"originalNodeId"];
    }
    if (list) {
        [dict setObject:list forKey:@"dataList"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_sortProjectSection];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_sortProjectSection
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 任务列添加引用 项目id，任务列id，引用的模块bean，引用的数据id */
-(void)requestAddQuoteWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_addTaskQuote];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addTaskQuote
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取某任务列表任务 */
-(void)requsetGetTaskWithSectionId:(NSNumber *)sectionId pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize rowIndex:(NSInteger)rowIndex filterParam:(NSDictionary *)filterParam{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (sectionId) {
        [dict setObject:sectionId forKey:@"id"];
    }
    if (filterParam) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:filterParam options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setObject:str forKey:@"filterParam"];
    }
    
//    if (pageNo) {
//        [dict setObject:pageNo forKey:@"pageNum"];
//    }
//    if (pageSize) {
//        [dict setObject:pageSize forKey:@"pageSize"];
//    }
    
    NSString *url = [super urlFromCmd:HQCMD_getSectionTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:(HQCMD)(HQCMD_getSectionTask + rowIndex)
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}



/** 创建任务 */
-(void)requestCreateTaskWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_createTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 创建子任务 */
-(void)requestCreateChildTaskWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_createChildTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createChildTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 任务详情 */
-(void)requestGetTaskDetailWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getTaskDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getTaskDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 子任务详情 */
-(void)requestGetChildTaskDetailWithChildTaskId:(NSNumber *)childTaskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (childTaskId) {
        [dict setObject:childTaskId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getChildTaskDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getChildTaskDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取任务的子任务 */
-(void)requestGetChildTaskListWithTaskId:(NSNumber *)taskId nodeCode:(NSString *)nodeCode{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (nodeCode) {
        [dict setObject:nodeCode forKey:@"parentNodeCode"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getChildTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getChildTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取个人任务的子任务 */
-(void)requestGetPersonnelChildTaskListWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelChildTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelChildTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取任务关联列表
 *@prama taskId 任务ID or 子任务ID
 *@prama taskType 任务关联 1,子任务关联2
 */
-(void)requestGetTaskRelationListWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"taskType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getTaskRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getTaskRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取任务被关联列表
 *@prama taskId 任务ID
 */
-(void)requestGetTaskRelatedListWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getTaskRelated];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getTaskRelated
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 新增任务关联的任务 */
-(void)requestAddTaskRelationWithDict:(NSDictionary *)dict{
    
    HQLog(@"========我来了==========");
    NSString *url = [super urlFromCmd:HQCMD_addTaskRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addTaskRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 引用任务关联 */
-(void)requestQuoteTaskRelationWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_quoteTaskRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_quoteTaskRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 取消任务关联 */
-(void)requestCancelTaskRelationWithDataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_cancelTaskRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_cancelTaskRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 取消个人任务关联 */
-(void)requestCancelPersonnelTaskRelationWithDataId:(NSNumber *)dataId fromType:(NSNumber *)fromType taskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"ids"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"fromType"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_cancelPersonnelTaskRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_cancelPersonnelTaskRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 任务拖拽排序
 @prama originalNodeId 原来分列id
 @prama toSubnodeId 目标子节点记录ID
 @prama dataList 任务id对象数组
 @prama moveId 移动任务id
 */
-(void)requestDragTaskToSortWithOriginalNodeId:(NSNumber *)originalNodeId toSubnodeId:(NSNumber *)toSubnodeId dataList:(NSArray *)dataList moveId:(NSNumber *)moveId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (originalNodeId) {
        [dict setObject:originalNodeId forKey:@"originalNodeId"];
    }
    if (toSubnodeId) {
        [dict setObject:toSubnodeId forKey:@"toSubnodeId"];
    }
    if (dataList) {
        [dict setObject:dataList forKey:@"dataList"];
    }
    if (moveId) {
        [dict setObject:moveId forKey:@"taskInfoId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_dragTaskSort];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_dragTaskSort
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 任务完成及激活 */
-(void)requestTaskFinishOrActiveWithTaskId:(NSNumber *)taskId completeStatus:(NSNumber *)completeStatus remark:(NSString *)remark{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (completeStatus) {
        [dict setObject:completeStatus forKey:@"completeStatus"];
    }
    if (remark) {
        [dict setObject:remark forKey:@"remark"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_finishOrActiveTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_finishOrActiveTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 子任务完成及激活 */
-(void)requestChildTaskFinishOrActiveWithTaskId:(NSNumber *)taskId completeStatus:(NSNumber *)completeStatus remark:(NSString *)remark{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (completeStatus) {
        [dict setObject:completeStatus forKey:@"completeStatus"];
    }
    if (remark) {
        [dict setObject:remark forKey:@"remark"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_finishOrActiveChildTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_finishOrActiveChildTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 个人任务完成及激活 */
-(void)requestPersonnelTaskFinishOrActiveWithTaskId:(NSNumber *)taskId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_finishOrActivePersonnelTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_finishOrActivePersonnelTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 任务or子任务点赞或取消点赞
 *@param taskId （分享，任务，子任务）记录id
 *@param status  0不点赞  1点赞
 *@param typeStatus 点赞类型，0 分享，1任务，2子任务
 */
-(void)requestTaskHeartWithTaskId:(NSNumber *)taskId status:(NSNumber *)status typeStatus:(NSNumber *)typeStatus{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"typeStatus"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskHeart];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_taskHeart
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 个人任务or子任务点赞或取消点赞 */
-(void)requestPersonnelTaskHeartWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType status:(NSNumber *)status{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"task_id"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"from_type"];
    }
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskHeart];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskHeart
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 点赞人员列表 */
-(void)requestTaskHeartPeopleWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"typeStatus"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskHeartPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_taskHeartPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 个人任务点赞人员列表 */
-(void)requestPersonnelTaskHeartPeopleWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"fromType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskHeartPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskHeartPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 任务层级 */
-(void)requsetTaskHierarchyWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskHierarchy];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_taskHierarchy
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 修改项目任务任务可见性 */
-(void)requsetTaskVisibleWithTaskId:(NSNumber *)taskId associatesStatus:(NSNumber *)associatesStatus taskType:(NSNumber *)taskType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (associatesStatus) {
        [dict setObject:associatesStatus forKey:@"associatesStatus"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"taskType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskVisible];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_taskVisible
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 修改个人任务可见性 */
-(void)requsetPersonnelTaskVisibleWithTaskId:(NSNumber *)taskId participantsOnly:(NSNumber *)participantsOnly fromType:(NSNumber *)fromType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"task_id"];
    }
    if (participantsOnly) {
        [dict setObject:participantsOnly forKey:@"participants_only"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"from_type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskVisible];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskVisible
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 校验任务
 *@prama taskId  任务id
 *@prama check  0待检验 1通过 2驳回
 *@prama content  备注
 */
-(void)requestTaskCheckWithTaskId:(NSNumber *)taskId status:(NSNumber *)status content:(NSString *)content{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    if (content) {
        [dict setObject:content forKey:@"content"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskCheck];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_taskCheck
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 校验子任务
 *@prama taskId  子任务id
 *@prama check  0待检验 1通过 2驳回
 *@prama content  备注
 */
-(void)requestChildTaskCheckWithTaskId:(NSNumber *)taskId status:(NSNumber *)status content:(NSString *)content{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    if (status) {
        [dict setObject:status forKey:@"status"];
    }
    if (content) {
        [dict setObject:content forKey:@"content"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_childTaskCheck];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_childTaskCheck
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 移动任务到某列 */
-(void)requestMoveTaskToNewNodeCode:(NSString *)newNodeCode nodeCode:(NSString *)nodeCode taskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (newNodeCode) {
        [dict setObject:newNodeCode forKey:@"newParentNodeCode"];
    }
    if (nodeCode) {
        [dict setObject:nodeCode forKey:@"nodeCode"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_taskMoveToOther];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_taskMoveToOther
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 复制任务到某列 */
-(void)requestCopyTaskToNewNodeCode:(NSString *)newNodeCode nodeCode:(NSString *)nodeCode taskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (newNodeCode) {
        [dict setObject:newNodeCode forKey:@"newParentNodeCode"];
    }
    if (nodeCode) {
        [dict setObject:nodeCode forKey:@"nodeCode"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskCopyToOther];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_taskCopyToOther
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除任务 */
-(void)requestDeleteTaskWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 删除子任务 */
-(void)requestDeleteChildTaskWithTaskChildId:(NSNumber *)taskChildId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskChildId) {
        [dict setObject:taskChildId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteChildTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteChildTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 任务列表（用于引用选择任务） */
-(void)requestGetQuoteTaskListWithKeyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize projectId:(NSNumber *)projectId from:(NSNumber *)from{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"project_id"];
    }
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    [dict setObject:@0 forKey:@"query_type"];
    
    if (from) {
        [dict setObject:from forKey:@"from"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_quoteTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_quoteTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 任务筛选自定义条件接口 */
-(void)requestGetProjectTaskFilterConditionWithProjectId:(NSNumber *)projectId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_queryProjectTaskCondition];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_queryProjectTaskCondition
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 任务筛选 */
-(void)requestProjectTaskFilterWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectTaskFilter];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectTaskFilter
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 个人任务筛选 */
-(void)requestPersonnelTaskFilterWithQueryType:(NSInteger)type queryWhere:(NSDictionary *)queryWhere sortField:(NSArray *)sortField dateFormat:(NSNumber *)dateFormat{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@(type) forKey:@"queryType"];
    
    if (queryWhere) {
        [dict setObject:queryWhere forKey:@"queryWhere"];
    }
    if (sortField) {
        [dict setObject:sortField forKey:@"sortField"];
    }
    if (dateFormat) {
        [dict setObject:dateFormat forKey:@"dateFormat"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskFilter];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskFilter
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 个人任务详情 */
-(void)requestPersonnelTaskDetailWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 个人任务子任务详情 */
-(void)requestPersonnelSubTaskDetailWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelSubTaskDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelSubTaskDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 某项目下的任务 */
-(void)requestTaskInProjectWithProjectId:(NSNumber *)projectId queryType:(NSNumber *)queryType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (queryType) {
        [dict setObject:queryType forKey:@"queryType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_taskInProject];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_taskInProject
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取项目任务协作人列表 */
-(void)requestGetProjectTaskCooperationPeopleListWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"typeStatus"];
    }
        
    [dict setObject:@1 forKey:@"all"];
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskCooperationPeopleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskCooperationPeopleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取项目任务角色 */
-(void)requestGetProjectTaskRoleWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"typeStatus"];
    }
    
    [dict setObject:@0 forKey:@"all"];
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskRole];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskRole
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
    
/** 获取个人任务协作人列表 */
-(void)requestGetPersonnelTaskCooperationPeopleListWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"fromType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskCooperationPeopleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskCooperationPeopleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取个人任务角色 */
-(void)requestGetPersonnelTaskRoleWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"fromType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskRole];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskRole
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** add项目任务协作人 */
-(void)requestAddProjectTaskCooperationPeopleWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_addProjectTaskCooperationPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addProjectTaskCooperationPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** add个人任务协作人*/
-(void)requestAddPersonnelTaskCooperationPeopleListWithTaskId:(NSNumber *)taskId typeStatus:(NSNumber *)typeStatus employeeIds:(NSString *)employeeIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (typeStatus) {
        [dict setObject:typeStatus forKey:@"fromType"];
    }
    if (employeeIds) {
        [dict setObject:employeeIds forKey:@"employeeIds"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_addPersonnelTaskCooperationPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_addPersonnelTaskCooperationPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 删除项目任务协作人 */
-(void)requestDeleteProjectTaskCooperationPeopleWithRecordId:(NSNumber *)recordId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (recordId) {
        [dict setObject:recordId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteProjectTaskCooperationPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteProjectTaskCooperationPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 删除个人任务协作人*/
-(void)requestDeletePersonnelTaskCooperationPeopleWithFromType:(NSNumber *)fromType taskId:(NSNumber *)taskId employeeIds:(NSString *)employeeIds{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"fromType"];
    }
    if (employeeIds) {
        [dict setObject:employeeIds forKey:@"employeeIds"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deletePersonnelTaskCooperationPeople];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_deletePersonnelTaskCooperationPeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 创建个人任务子任务 */
-(void)requestCreatePersonnelChildTaskWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_createPersonnelSubTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_createPersonnelSubTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 个人任务引用个人任务 */
-(void)requestPersonnelTaskQuotePersonnelTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskQuotePersonnelTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskQuotePersonnelTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 个人任务关联 */
-(void)requestPersonnelTaskRelationListWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"fromType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskRelationList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskRelationList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 个人任务被关联 */
-(void)requestPersonnelTaskByRelatedListWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskByRelated];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskByRelated
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 编辑个人任务 */
-(void)requestEditPersonnelTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 编辑个人子任务 */
-(void)requestEditPersonnelSubTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_personnelSubTaskEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelSubTaskEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 编辑项目任务自定义数据 */
-(void)requestEditProjectTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectTaskEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectTaskEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 个人任务删除 */
-(void)requsetPersonnelTaskDeleteWithTaskIds:(NSString *)taskIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskIds) {
        [dict setObject:taskIds forKey:@"ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelTaskDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelTaskDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];

}
/** 个人任务子任务删除 */
-(void)requsetPersonnelSubTaskDeleteWithTaskIds:(NSString *)taskIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskIds) {
        [dict setObject:taskIds forKey:@"ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_personnelSubTaskDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_personnelSubTaskDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取项目任务提醒 */
-(void)requestGetTaskRemainWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"fromType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskRemain];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskRemain
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 设置项目任务提醒 */
-(void)requsetSettingTaskRemainWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_saveProjectTaskRemain];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveProjectTaskRemain
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 更新项目任务提醒 */
-(void)requsetUpdateTaskRemainWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectTaskRemain];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectTaskRemain
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取所有项目 */
-(void)requsetAllProjectWithKeyword:(NSString *)keyword type:(NSInteger)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    [dict setObject:@(type) forKey:@"type"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_getAllProject];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAllProject
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取个人任务列表 */
-(void)requestGetPersonnelTaskListWithKeyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (keyword) {
        [dict setObject:keyword forKey:@"keyword"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取工作流 */
-(void)requsetGetProjectWorkflow{
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectWorkflow];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getProjectWorkflow
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 工作流预览 */
-(void)requsetProjectWorkflowPreviewWithWorkflowId:(NSNumber *)workflowId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (workflowId) {
        [dict setObject:workflowId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectWorkflowPreview];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectWorkflowPreview
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取个人任务筛选条件 */
-(void)requsetGetPersonnelTaskFilterCondition{
    
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskFilterCondition];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getPersonnelTaskFilterCondition
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取个人权限下的所有自定义模块 */
-(void)requestGetMyselfCustomModule{
    
    NSString *url = [super urlFromCmd:HQCMD_getMyselfCustomModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getMyselfCustomModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取工作台列表 */
-(void)requestGetWorkBenchList{
    
    NSString *url = [super urlFromCmd:HQCMD_getWorkBenchList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getWorkBenchList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取时间工作流数据 workBenchType 1:超期未完成 2:今日要做 3:明天要做 4:以后要做 */
-(void)requestGetWorkBenchDataWithWorkBenchType:(NSNumber *)workBenchType index:(NSInteger)index pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (workBenchType) {
        [dict setObject:workBenchType forKey:@"workbench_type"];
    }
    [dict setObject:@"" forKey:@"module_ids"];
    [dict setObject:@"" forKey:@"memeber_ids"];
    [dict setObject:@1 forKey:@"workbench_id"];
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getWorkBenchTimeData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:(HQCMD)(HQCMD_getWorkBenchTimeData + index)
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取时间工作流数据 workBenchType 1:超期未完成 2:今日要做 3:明天要做 4:以后要做 */
-(void)requestGetWorkBenchDataWithWorkBenchType:(NSNumber *)workBenchType index:(NSInteger)index pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize memeberIds:(NSString *)memeberIds{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (workBenchType) {
        [dict setObject:workBenchType forKey:@"workbench_type"];
    }
    [dict setObject:@"" forKey:@"module_ids"];
    if (memeberIds) {
        [dict setObject:memeberIds forKey:@"memeber_ids"];
    }else{
        [dict setObject:@"" forKey:@"memeber_ids"];
    }
    [dict setObject:@1 forKey:@"workbench_id"];
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getWorkBenchTimeData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:(HQCMD)(HQCMD_getWorkBenchTimeData + index)
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 工作台流程列表 */
-(void)requestEnterpriseWorkBenchFlow{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@1 forKey:@"fromType"];
    
    NSString *url = [super urlFromCmd:HQCMD_enterpriseWorkBenchFlow];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_enterpriseWorkBenchFlow
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取企业工作流数据 */
-(void)requestGetEnterpriseWorkBenchDataWithFlowId:(NSString *)flowId index:(NSInteger)index{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (flowId) {
        [dict setObject:flowId forKey:@"flowId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_enterpriseWorkBenchFlowData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:(HQCMD)(HQCMD_enterpriseWorkBenchFlowData+index)
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 时间工作台移动 */
-(void)requestTimeWorkBenchMoveWithTimeId:(NSNumber *)timeId workbenchTag:(NSNumber *)workbenchTag dataList:(NSArray *)dataList{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (timeId) {
        [dict setObject:timeId forKey:@"timeId"];
    }
    if (workbenchTag) {
        [dict setObject:workbenchTag forKey:@"workbenchTag"];
    }
    if (dataList) {
        [dict setObject:dataList forKey:@"dataList"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moveTimeWorkBench];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_moveTimeWorkBench
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 企业工作台移动 */
-(void)requestEnterpriseWorkBenchMoveWithTaskId:(NSNumber *)taskId flowId:(NSString *)flowId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (flowId) {
        [dict setObject:flowId forKey:@"flowId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moveEnterpriseWorkBench];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_moveEnterpriseWorkBench
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 项目模板 or 个人模板 */
-(void)requestGetProjectModelWithTemplateRole:(NSNumber *)templateRole templateType:(NSNumber *)templateType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (templateRole) {
        [dict setObject:templateRole forKey:@"templateRole"];
    }
    if (templateType) {
        [dict setObject:templateType forKey:@"templateType"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectTemplateList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectTemplateList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 项目模板预览 */
-(void)requestGetProjectTemplatePreviewWithTemplateId:(NSNumber *)templateId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (templateId) {
        [dict setObject:templateId forKey:@"tempId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectTemplatePreview];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectTemplatePreview
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取某人在某项目的角色及权限 */
-(void)requestGetProjectRoleAndAuthWithProjectId:(NSNumber *)projectId employeeId:(NSNumber *)employeeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (employeeId) {
        [dict setObject:employeeId forKey:@"eid"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectRoleAndAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectRoleAndAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 角色项目任务权限 */
-(void)requestGetRoleProjectTaskAuthWithProjectId:(NSNumber *)projectId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskRoleAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskRoleAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 项目任务查看状态 */
-(void)requsetGetProjectTaskSeeStatusWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId taskType:(NSNumber *)taskType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"taskType"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskSeeStatus];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskSeeStatus
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 个人任务查看状态 */
-(void)requsetGetPersonnelTaskSeeStatusWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"fromType"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskSeeStatus];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskSeeStatus
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 保存项目任务设置重复 */
-(void)requsetSaveProjectTaskRepeatWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_saveProjectTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveProjectTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 更新项目任务设置重复 */
-(void)requsetUpdateProjectTaskRepeatWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取项目任务设置重复 */
-(void)requsetGetProjectTaskRepeatWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取个人任务提醒 */
-(void)requsetGetPersonnelTaskRemindWithTaskId:(NSNumber *)taskId fromType:(NSNumber *)fromType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (fromType) {
        [dict setObject:fromType forKey:@"fromType"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskRemind];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskRemind
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 保存个人任务提醒 */
-(void)requsetSavePersonnelTaskRemindWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_savePersonnelTaskRemind];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savePersonnelTaskRemind
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 更新个人任务提醒 */
-(void)requsetUpdatePersonnelTaskRemindWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updatePersonnelTaskRemind];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updatePersonnelTaskRemind
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 获取个人任务设置重复 */
-(void)requsetGetPersonnelTaskRepeatWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getPersonnelTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getPersonnelTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 保存个人任务设置重复 */
-(void)requsetSavePersonnelTaskRepeatWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_savePersonnelTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savePersonnelTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 更新个人任务设置重复 */
-(void)requsetUpdatePersonnelTaskRepeatWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updatePersonnelTaskRepeat];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updatePersonnelTaskRepeat
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 编辑项目任务 */
-(void)requestUpdateProjectTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 编辑项目子任务 */
-(void)requestUpdateProjectChildTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_updateProjectChildTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateProjectChildTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取项目任务的完成权限及填写激活原因 taskType:1主任务，2子任务 */
-(void)requsetGetProjectTaskFinishAuthAndActiveCauseWithProjectId:(NSNumber *)projectId taskId:(NSNumber *)taskId taskType:(NSNumber *)taskType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectId) {
        [dict setObject:projectId forKey:@"project_id"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"task_id"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"task_type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectFinishAndActiveAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectFinishAndActiveAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 移出成员是否需要指定工作交接人 */
-(void)requsetDeleteProjectPeopleTransferTaskWithProjectMemberId:(NSNumber *)projectMemberId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (projectMemberId) {
        [dict setObject:projectMemberId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_deleteProjectPeopleTransferTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_deleteProjectPeopleTransferTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 层级视图取消关联数据 */
-(void)requestBoardDataCancelRelationshipWithIds:(NSString *)ids{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!IsStrEmpty(ids)) {
        [dict setObject:ids forKey:@"ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_boardCancelQuote];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_boardCancelQuote
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


#pragma mark 项目分享
/** 新增分享 */
- (void)requestProjectShareControllerSaveWithModel:(TFProjectShareSendModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 修改分享 */
- (void)requestProjectShareControllerEditWithModel:(TFProjectShareSendModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除分享 */
- (void)requestProjectShareControllerDeleteWithId:(NSNumber *)shareId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 关联变更 */
- (void)requestProjectShareControllerEditRelevanceWithId:(NSNumber *)shareId itemsArr:(NSArray *)itemsArr {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    if (itemsArr) {
        
        [dict setObject:itemsArr forKey:@"itemsArr"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerEditRelevance];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerEditRelevance
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 分享置顶 */
- (void)requestProjectShareControllerShareStickWithId:(NSNumber *)shareId status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    if (status) {
        
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerShareStick];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerShareStick
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 分享点赞 */
- (void)requestProjectShareControllerSharePraiseWithId:(NSNumber *)shareId status:(NSNumber *)status {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    if (status) {
        
        [dict setObject:status forKey:@"status"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerSharePraise];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerSharePraise
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 分享详情 */
- (void)requestProjectShareControllerQueryByIdWithId:(NSNumber *)shareId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerQueryById];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerQueryById
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 分享列表 */
- (void)requestProjectShareControllerQueryListWithData:(NSNumber * )pageNum pageSize:(NSNumber * )pageSize keyword:(NSString *)keyword type:(NSNumber * )type projectId:(NSNumber *)projectId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    if (keyword) {
        
        [dict setObject:keyword forKey:@"keyword"];
    }
    
    if (type) {
        
        [dict setObject:type forKey:@"type"];
    }
    
    if (projectId) {
        
        [dict setObject:projectId forKey:@"projectId"];
    }
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerQueryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerQueryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取关联内容 */
- (void)requestProjectShareControllerQueryRelationListWithData:(NSNumber * )shareId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerQueryRelationList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerQueryRelationList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 分享关联内容 */
- (void)requestProjectShareControllerSaveRelationWithModel:(TFProjectShareRelatedModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerSaveRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerSaveRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 取消关联内容 */
- (void)requestProjectShareControllerCancleRelationWithId:(NSString *)shareId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (shareId) {
        
        [dict setObject:shareId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectShareControllerCancleRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectShareControllerCancleRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark 项目文库
/** 项目文库列表 */
- (void)requestProjectLibraryQueryLibraryListWithId:(NSNumber *)fileId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryQueryLibraryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryQueryLibraryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 文库任务列表 */
- (void)requestprojectLibraryQueryFileLibraryListWithId:(NSNumber *)dataId type:(NSString *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:dataId forKey:@"id"];
    [dict setObject:type forKey:@"library_type"];
    [dict setObject:pageNum forKey:@"pageNum"];
    [dict setObject:pageSize forKey:@"pageSize"];
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryQueryFileLibraryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryQueryFileLibraryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 文库列表 */
- (void)requestprojectLibraryQueryTaskLibraryListWithId:(NSNumber *)dataId type:(NSString *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (type) {
        [dict setObject:type forKey:@"library_type"];
    }
    
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (keyWord) {
        [dict setObject:keyWord forKey:@"keyWord"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryQueryTaskLibraryList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryQueryTaskLibraryList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 文库根搜索列表 */
- (void)requestprojectLibrarySearchWithProjectId:(NSNumber *)projectId pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize keyWord:(NSString *)keyWord {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"project_id"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (keyWord) {
        [dict setObject:keyWord forKey:@"keyWord"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryRootSearch];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryRootSearch
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 添加文库文件夹 */
- (void)requestProjectLibrarySavaLibraryWithData:(NSString *)fileName projectId:(NSNumber *)projectId parentId:(NSNumber *)parentId type:(NSNumber *)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileName) {
        
        [dict setObject:fileName forKey:@"name"];
    }
    if (parentId) {
        
        [dict setObject:parentId forKey:@"parent_id"];
    }
    if (projectId) {
        
        [dict setObject:projectId forKey:@"project_id"];
    }
    if (type) {
        
        [dict setObject:type forKey:@"type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibrarySavaLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibrarySavaLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 修改文库文件夹 */
- (void)requestProjectLibraryEditLibraryWithData:(NSString *)fileName fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileName) {
        
        [dict setObject:fileName forKey:@"name"];
    }
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (projectId) {
        
        [dict setObject:projectId forKey:@"project_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryEditLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryEditLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除文库文件夹 */
- (void)requestProjectLibraryDelLibraryWithData:(NSString *)fileName fileId:(NSNumber *)fileId projectId:(NSNumber *)projectId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileName) {
        
        [dict setObject:fileName forKey:@"name"];
    }
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (projectId) {
        
        [dict setObject:projectId forKey:@"project_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibraryDelLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibraryDelLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 共享文件夹 */
- (void)requestProjectLibrarySavaLibraryWithData:(NSNumber *)fileId employeeId:(NSNumber *)employeeId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (employeeId) {
        
        [dict setObject:employeeId forKey:@"employee_id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectLibrarySharLibrary];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectLibrarySharLibrary
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 上传文件 */
- (void)requestCommonFileProjectUploadWithData:(NSNumber *)fileId projectId:(NSNumber *)projectId images:(NSArray *)images {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    if (projectId) {
        
        [dict setObject:projectId forKey:@"project_id"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_commonFileProjectUpload];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_commonFileProjectUpload
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 下载文件 */
- (void)requestCommonFileProjectDownloadWithData:(NSNumber *)fileId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_commonFileProjectDownload];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_commonFileProjectDownload
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 文件下载记录 */
- (void)requestFileProjectDownloadRecordWithFileId:(NSNumber *)fileId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (fileId) {
        
        [dict setObject:fileId forKey:@"id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_FileProjectDownloadRecord];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_FileProjectDownloadRecord
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 工作台切换成员权限 */
- (void)requestWorkBenchChangePeopleAuth{
    
    NSString *url = [super urlFromCmd:HQCMD_workBenchChangeAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_workBenchChangeAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 工作台切换人员列表 */
-(void)requestChangePeopleList{
    
    NSString *url = [super urlFromCmd:HQCMD_workBenchChangePeopleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_workBenchChangePeopleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/****************新版协作接口****************/
/** 获取所有节点 */
-(void)requestAllNodeWithProjectId:(NSNumber *)projectId limitNodeType:(NSNumber *)limitNodeType filterParam:(NSDictionary *)filterParam{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        
        [dict setObject:projectId forKey:@"id"];
    }
    if (limitNodeType) {
        
        [dict setObject:limitNodeType forKey:@"limitNodeType"];
    }
    if (filterParam) {
        
        [dict setObject:[HQHelper dictionaryToJson:filterParam] forKey:@"filterParam"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_projectAllNode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectAllNode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 获取模板节点 */
-(void)requestTemplateWithTempId:(NSNumber *)tempId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (tempId) {
        
        [dict setObject:tempId forKey:@"tempId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectTempAllNode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectTempAllNode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 新增节点 */
-(void)requestAddNodeWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectAddNode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectAddNode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 更新节点 */
-(void)requestUpdateNodeWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectUpdateNode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectUpdateNode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 删除节点 */
-(void)requestDeleteNodeWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectDeleteNode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectDeleteNode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 新增任务 */
-(void)requestAddTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectAddTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectAddTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 编辑任务 */
-(void)requestUpdateTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectUpdateTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectUpdateTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 新增子任务 */
-(void)requestAddSubTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectAddSubTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectAddSubTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 编辑子任务 */
-(void)requestUpdateSubTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectUpdateSubTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectUpdateSubTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 复制任务 */
-(void)requestCopyTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectCopyTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectCopyTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 移动任务 */
-(void)requestMoveTaskWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_projectMoveTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_projectMoveTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 子任务列表 */
-(void)requestGetSubTaskWithSubTaskId:(NSNumber *)subTaskId parentNodeCode:(NSNumber *)parentNodeCode{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (subTaskId) {
        
        [dict setObject:subTaskId forKey:@"id"];
    }
    if (parentNodeCode) {
        
        [dict setObject:parentNodeCode forKey:@"parentNodeCode"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_projectGetSubTask];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_projectGetSubTask
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 任务混合动态
 * @prama taskId 任务编号
 * @prama taskType 1:主任务，2子任务
 * @prama dynamicType 0：全部，1评论，2查看状态，3操作日志
 * @prama pageSize 获取数量
 */
-(void)requestTaskHybirdDynamicWithTaskId:(NSNumber *)taskId taskType:(NSNumber *)taskType dynamicType:(NSNumber *)dynamicType pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    if (taskType) {
        [dict setObject:taskType forKey:@"taskType"];
    }
    if (dynamicType) {
        [dict setObject:dynamicType forKey:@"dynamicType"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_taskHybirdDynamic];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_taskHybirdDynamic
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 个人任务列表 */
-(void)requestNewPersonnelTaskListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize queryWhere:(NSDictionary *)queryWhere sortField:(NSString *)sortField dateFormat:(NSNumber *)dateFormat queryType:(NSNumber *)queryType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (queryWhere) {
        [dict setObject:queryWhere forKey:@"queryWhere"];
    }
    if (sortField) {
        [dict setObject:sortField forKey:@"sortField"];
    }
    if (dateFormat) {
        [dict setObject:dateFormat forKey:@"dateFormat"];
    }
    if (queryType) {
        [dict setObject:queryType forKey:@"queryType"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_newPersonnelTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_newPersonnelTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 项目任务列表 */
-(void)requestNewProjectTaskListWithProjectId:(NSNumber *)projectId PageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize queryWhere:(NSDictionary *)queryWhere sortField:(NSString *)sortField dateFormat:(NSNumber *)dateFormat queryType:(NSNumber *)queryType bean:(NSString *)bean{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (queryWhere) {
        [dict setObject:queryWhere forKey:@"queryWhere"];
    }
    if (sortField) {
        [dict setObject:sortField forKey:@"sortField"];
    }
    if (dateFormat) {
        [dict setObject:dateFormat forKey:@"dateFormat"];
    }
    if (queryType) {
        [dict setObject:queryType forKey:@"queryType"];
    }
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_newProjectTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_newProjectTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Responses
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
            case HQCMD_createProject:{// 创建项目
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_updateProject:{// 设置项目
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getProjectList:{// 获取项目列表
                NSDictionary *dict = data[kData];
                TFProjectListModel *listModel = [[TFProjectListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:listModel];
            }
                break;
            case HQCMD_getProjecDetail:{// 获取项目详情
                
                NSDictionary *dict = data[kData];
                TFProjectModel *model = [[TFProjectModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_changeProjectStatus:{// 变更项目状态
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_addProjectPeople:{// 增加项目成员
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_deleteProjectPeople:{// 删除项目成员
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;

            case HQCMD_getProjectPeople:{// 获取项目成员列表
                NSDictionary *dataDict = data[kData];
                NSArray *arr = [dataDict valueForKey:@"dataList"];
                NSMutableArray *peoples = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFProjectPeopleModel *model = [[TFProjectPeopleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [peoples addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:peoples];
            }
                break;
            case HQCMD_getProjectRoleList:{// 获取项目角色列表
                
                NSDictionary *dataDict = data[kData];
                NSArray *arr = [dataDict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_updateProjectRole:{// 修改项目角色
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getProjectLabel:// 获取项目标签
            case HQCMD_getPersonnelLabel:{// 获取个人标签
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFProjectLabelModel *model = [[TFProjectLabelModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_addProjectLabel:{// 增加项目标签
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_repositoryLabel:{// 获取标签库
                
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFProjectLabelModel *model = [[TFProjectLabelModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_updateProjectStar:{// 更新项目星标
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_updateProjectProgress:{// 更新项目进度
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_createProjectSection:{// 创建项目分组
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_updateProjectSection:{// 更新项目分组
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createProjectSectionRows:{// 创建项目分组任务列
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_updateProjectSectionRows:{// 创建项目分组任务列
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getProjectAllDot:{// 获取项目所有节点
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *columns = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFProjectColumnModel *model = [[TFProjectColumnModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [columns addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:columns];
            }
                break;
            case HQCMD_getProjectColumn:{// 获取项目主节点
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *columns = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFProjectRowModel *model = [[TFProjectRowModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [columns addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:columns];
            }
                break;
            case HQCMD_getProjectSection:{// 获取项目子节点
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *columns = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFProjectRowModel *model = [[TFProjectRowModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [columns addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:columns];
            }
                break;
            case HQCMD_deleteProjectColumn:{// 删除项目主节点
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_deleteProjectSection:{// 删除项目子节点
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_sortProjectColumn:{//  项目主节点排序
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_sortProjectSection:{//  项目子节点排序
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_addTaskQuote:  // 添加引用
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createTask:{// 创建任务
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createChildTask:{// 创建项目任务子任务
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createPersonnelSubTask:{// 创建个人任务子任务
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getTaskDetail:{// 获取任务详情
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getChildTaskDetail:{// 获取子任务详情
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getTaskRelation:{// 任务的关联
                
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_getTaskRelated:{// 任务的被关联
                
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_addTaskRelation:{// 添加任务关联任务
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_quoteTaskRelation:{// 添加任务关联引用
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_cancelTaskRelation:{// 取消任务关联
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_cancelPersonnelTaskRelation:{// 取消个人任务关联
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_dragTaskSort:{// 拖拽任务排序
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getChildTaskList:{// 子任务列表
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_getPersonnelChildTaskList:{// 个人任务子任务列表
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_finishOrActiveTask:{// 完成任务或激活
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_finishOrActiveChildTask:{// 完成子任务或激活
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_finishOrActivePersonnelTask:{// 完成个人任务或激活
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_taskHeart:{// 任务或子任务点赞或取消点赞
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_personnelTaskHeart:{// 个人任务或子任务点赞或取消点赞
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_taskHeartPeople:{// 任务或子任务点赞列表
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *peoples = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [peoples addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:peoples];
            }
                break;
            case HQCMD_personnelTaskHeartPeople:{// 个人任务或子任务点赞列表
                NSArray *arr = data[kData];
                NSMutableArray *peoples = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [peoples addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:peoples];
            }
                break;
            case HQCMD_taskHierarchy:{// 任务层级
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskVisible:{// 任务协作人可见
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskVisible:{// 个人任务协作人可见
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskCheck:{// 任务校验
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_childTaskCheck:{// 子任务校验
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskMoveToOther:{// 任务移动
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskCopyToOther:{// 复制移动
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_deleteTask:{// 任务删除
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_deleteChildTask:{// 子任务删除
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_quoteTaskList:{// 引用任务列表
                NSDictionary *dict = data[kData];
                TFQuoteTaskListModel *model = [[TFQuoteTaskListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_queryProjectTaskCondition:{// 任务筛选自定义条件
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectTaskFilter:{// 任务筛选
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskFilter:{// 个人任务筛选
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskDetail:{// 个人任务详情
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelSubTaskDetail:{// 个人任务子任务详情
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskInProject:{// 项目中的任务
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectTaskCooperationPeopleList:{// 获取项目任务协作人列表
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                NSMutableArray *peoples = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFProjectPeopleModel *model = [[TFProjectPeopleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [peoples addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:peoples];
            }
                break;
            case HQCMD_getProjectTaskRole:{// 获取项目任务角色
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_getPersonnelTaskCooperationPeopleList:{// 获取个人任务协作人列表
                NSArray *arr = data[kData];
                NSMutableArray *peoples = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [peoples addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:peoples];
            }
                break;
            case HQCMD_getPersonnelTaskRole:{// 个人任务角色
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_addProjectTaskCooperationPeople:{// 项目任务添加协作人
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_addPersonnelTaskCooperationPeople:{// 个人任务添加协作人
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_deleteProjectTaskCooperationPeople:{// 项目任务删除协作人
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_deletePersonnelTaskCooperationPeople:{// 个人任务删除协作人
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskQuotePersonnelTask:  // 个人任务引用个人任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskRelationList:{// 个人任务的关联
                
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_personnelTaskByRelated:{// 个人任务被关联
                
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_personnelTaskEdit:{// 个人任务编辑
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelSubTaskEdit:{// 个人任务子任务编辑
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectTaskEdit:{// 项目任务 or 子任务编辑
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelTaskDelete:{// 个人任务删除
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_personnelSubTaskDelete:{// 个人任务子任务删除
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectTaskRemain:{// 获取项目任务提醒
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_saveProjectTaskRemain:{// 保存项目任务提醒
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updateProjectTaskRemain:{// 更新项目任务提醒
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getAllProject:{// 获取所有项目
                
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dd in arr) {
                    TFProjectModel *model = [[TFProjectModel alloc] initWithDictionary:dd error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getPersonnelTaskList:  // 获取个人任务列表
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_getProjectWorkflow:  // 获取工作流
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectWorkflowPreview:  // 工作流预览
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getPersonnelTaskFilterCondition:  // 获取个人任务筛选条件
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getMyselfCustomModule:  // 获取自定义模块列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getWorkBenchList:  // 获取工作台列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_enterpriseWorkBenchFlow:  // 获取企业工作台流程
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_moveTimeWorkBench:  // 移动时间工作台数据
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_moveEnterpriseWorkBench:  // 移动企业工作台数据
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectTemplateList:  // 项目模板列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectTemplatePreview:  // 项目模板模板
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *columns = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFProjectColumnModel *model = [[TFProjectColumnModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [columns addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:columns];
            }
                break;
            case HQCMD_getProjectRoleAndAuth:  // 项目权限及角色
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectTaskRoleAuth:  // 项目任务角色权限
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectTaskSeeStatus:  // 项目任务查看状态
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:[dict valueForKey:@"dataList"]];
            }
                break;
            case HQCMD_getPersonnelTaskSeeStatus:  // 个人任务查看状态
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_saveProjectTaskRepeat:  // 保存项目任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updateProjectTaskRepeat:  // 更新项目任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectTaskRepeat:  // 获取项目任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getPersonnelTaskRemind:  // 获取个人任务提醒
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_savePersonnelTaskRemind:  // 保存个人任务提醒
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updatePersonnelTaskRemind:  // 更新个人任务提醒
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getPersonnelTaskRepeat:  // 获取个人任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_savePersonnelTaskRepeat:  // 保存个人任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updatePersonnelTaskRepeat:  // 更新个人任务重复
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updateProjectTask:  // 编辑项目任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_updateProjectChildTask:  // 编辑项目子任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getProjectFinishAndActiveAuth:  // 获取任务完成及激活的权限
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_deleteProjectPeopleTransferTask:  // 移出成员是否需要指定工作交接人
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_boardCancelQuote:  // 层级视图取消关联
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_newPersonnelTaskList:  // 个人任务列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_newProjectTaskList:  // 项目任务列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
                
                
                
                
                
                
                
                
                

            case HQCMD_projectShareControllerSave:  // 新增分享
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            
            case HQCMD_projectShareControllerEdit:  // 修改分享
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
           
            case HQCMD_projectShareControllerDelete:  // 删除分享
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            
            case HQCMD_projectShareControllerEditRelevance:  // 关联变更
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            
            case HQCMD_projectShareControllerShareStick:  // 分享置顶
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
           
            case HQCMD_projectShareControllerSharePraise:  // 分享点赞
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            
            case HQCMD_projectShareControllerQueryById:  // 分享详情
            {
                
                NSDictionary *dic = data[kData];
                
                TFProjectShareInfoModel *model = [[TFProjectShareInfoModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectShareControllerQueryList:  // 分享列表
            {
                NSDictionary *dic = data[kData];
                
                TFProjectShareMainModel *model = [[TFProjectShareMainModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectLibraryQueryLibraryList:  // 项目文库列表
            {
                NSDictionary *dic = data[kData];
                
                TFProjectFileMainModel *model = [[TFProjectFileMainModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectLibraryQueryFileLibraryList:  // 任务文库列表
            {
                NSDictionary *dic = data[kData];
                
                TFProjectFileMainModel *model = [[TFProjectFileMainModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectLibraryRootSearch:  // 文库根搜索列表
            case HQCMD_projectLibraryQueryTaskLibraryList:  // 文库列表
            {
                NSDictionary *dic = data[kData];
                
                TFProjectFileSubModel *model = [[TFProjectFileSubModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_projectLibrarySavaLibrary:  // 添加文件夹
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;

            case HQCMD_projectLibraryEditLibrary:  // 修改文件夹
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_projectLibraryDelLibrary:  // 删除文件夹
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
                
            case HQCMD_projectShareControllerQueryRelationList:  //获取关联内容
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
                
            case HQCMD_projectShareControllerCancleRelation:  //取消关联内容
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_projectShareControllerSaveRelation:  //分享关联内容
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_workBenchChangeAuth:  //工作台切换人权限
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
                case HQCMD_FileProjectDownloadRecord:
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFDownloadRecordModel *model = [[TFDownloadRecordModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [array addObject:model];
                    }
                }
                
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
            case HQCMD_workBenchChangePeopleList:
            {
                NSDictionary *di = data[kData];
                NSArray *arr = [di valueForKey:@"dataList"];
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [array addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                /** *************新版项目接口*********** */
            case HQCMD_projectAllNode:  // 项目所有节点
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectTempAllNode:  // 项目模板节点
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectAddNode:  // 新增节点
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectUpdateNode:  // 更新节点
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectDeleteNode:  // 删除节点
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectAddTask:  // 新增任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectUpdateTask:  // 编辑任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectAddSubTask:  // 新增子任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectUpdateSubTask:  // 编辑子任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectCopyTask:  // 复制任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectMoveTask:  // 移动任务
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_projectGetSubTask:  // 子任务列表
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_taskHybirdDynamic:  // 混合动态
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *datas = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    TFTaskHybirdDynamicModel *model = [[TFTaskHybirdDynamicModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [datas addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:datas];
            }
                break;
                

                
            default:// 此处用于加载项目任务列数据（并发多列请求）or 时间工作流数据 or 企业工作流数据
            {
                NSDictionary *dic = data[kData];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dic];
            }
                break;
        }
        [super succeedCallbackWithResponse:resp];
    }
}

@end
