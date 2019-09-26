//
//  TFProjectBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectBL.h"

@implementation TFProjectBL

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
/** 创建项目分组 */
-(void)requestCreateProjectSectionWithModel:(TFProjectSectionModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"projectId"];
    }
    
    if (model.title) {
        [dict setObject:model.title forKey:@"title"];
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
/** 创建项目分组任务列表 */
-(void)requestCreateProjectSectionTasksWithModel:(TFProjectRowModel *)model{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (model.projectId) {
        [dict setObject:model.projectId forKey:@"projectId"];
    }
    
    if (model.sectionId) {
        [dict setObject:model.sectionId forKey:@"sectionId"];
    }
    
    if (model.name) {
        [dict setObject:model.name forKey:@"name"];
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

/** 创建任务(子任务) */
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

/** 项目列表 */
-(void)requestGetProjectListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNo) {
        [dict setObject:pageNo forKey:@"pageNo"];
    }
    
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getProjectList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getProjectList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 项目详情 */
-(void)requestGetProjectDetailWithProjectId:(NSNumber *)projectId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (projectId) {
        [dict setObject:projectId forKey:@"projectId"];
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
/** 任务列表 */
-(void)requestGetTaskListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNo) {
        [dict setObject:pageNo forKey:@"pageNo"];
    }
    
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getTaskList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getTaskList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];

}
/** 任务详情 */
-(void)requestGetTaskDetailWithTaskId:(NSNumber *)taskId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
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

#pragma mark - Responses
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
            case HQCMD_createProject:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createProjectSection:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createProjectSectionRows:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_createTask:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getProjectList:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getProjecDetail:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getTaskList:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_getTaskDetail:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            default:
                break;
        }
        [super succeedCallbackWithResponse:resp];
    }
}




@end
