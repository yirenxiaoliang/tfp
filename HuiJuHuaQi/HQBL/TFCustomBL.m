//
//  TFCustomBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomBL.h"
#import "TFCustomBaseModel.h"
#import "TFApplicationModel.h"
#import "TFCustomListModel.h"
#import "TFBeanTypeModel.h"
#import "TFFilterModel.h"
#import "TFCustomDetailRefrenceModel.h"
#import "TFCustomAuthModel.h"
#import "TFCustomChangeModel.h"
#import "TFCustomerCommentModel.h"
#import "TFCustomerDynamicModel.h"
#import "TFReferenceListModel.h"
#import "TFApprovalListItemModel.h"
#import "TFApprovalFlowModel.h"
#import "TFApprovalListModel.h"
#import "TFHighseaModel.h"
#import "TFStatisticsListModel.h"
#import "TFEmialApproverModel.h"
#import "TFAutoMatchRuleModel.h"

@implementation TFCustomBL

/** 获取布局 
 *
 *  @prama bean 模块bean 
 *  @prama taskKey
 *  @prama operationType  1:自定义表单 2:新增 3:编辑 4:详情
 *  @param dataId 某条数据id(详情时数据id)
 *  @param processFieldV 流程字段版本
 *  @param isSeasPool 是否为公海池
 */
- (void)requestCustomLayoutWithBean:(NSString *)bean taskKey:(NSString *)taskKey operationType:(NSNumber *)operationType dataId:(NSString *)dataId isSeasPool:(NSString *)isSeasPool processFieldV:(NSNumber *)processFieldV{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (taskKey) {
        [dic setObject:taskKey forKey:@"taskKey"];
    }
    if (operationType) {
        [dic setObject:operationType forKey:@"operationType"];
    }
    
    if (dataId) {
        [dic setObject:dataId forKey:@"dataId"];
    }
    if (isSeasPool) {
        [dic setObject:isSeasPool forKey:@"isSeasPool"];
    }
    
    if (processFieldV) {
        [dic setObject:processFieldV forKey:@"processFieldV"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customLayout];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customLayout
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取任务布局（项目任务和个人任务，以bean区分）
 项目任务的自定义：bean:  project_custom_ + 项目ID
 个人任务的自定义 bean : project_custom
 */
-(void)requestTaskLayoutWithBean:(NSString *)bean{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customTaskLayout];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customTaskLayout
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 保存项目任务数据 */
-(void)requestSaveTaskLayoutDataWithData:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_saveTaskLayoutData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveTaskLayoutData
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 保存个人任务数据 */
-(void)requestSavePersonnelDataWithData:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_savePersonnelData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_savePersonnelData
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取自定义应用列表 */
- (void)requestCustomApplicationListWithApprovalFlag:(NSString *)approvalFlag{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (approvalFlag) {
        [dic setObject:approvalFlag forKey:@"approvalFlag"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApplicationList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customApplicationList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 编辑常用模块列表 */
- (void)requestCustomOftenApplicationListWithModules:(NSArray *)modules{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (modules) {
        [dic setObject:modules forKey:@"module_ids"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApplicationOften];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customApplicationOften
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 新增保存 */
- (void)requsetCustomSaveWithDictData:(NSDictionary *)dictData{

    
    NSString *url = [super urlFromCmd:HQCMD_customSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dictData
                                            cmdId:HQCMD_customSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}

/** 删除 */
- (void)requsetCustomDeleteWithBean:(NSString *)bean dataId:(NSNumber *)dataId subformFields:(NSString *)subformFields{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    if (dataId) {
        [dic setObject:dataId forKey:@"ids"];
    }
    
    if (!IsStrEmpty(subformFields)) {
        [dic setObject:subformFields forKey:@"subformFields"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 编辑保存 */
- (void)requsetCustomEditWithDictData:(NSDictionary *)dictData{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dictData
                                            cmdId:HQCMD_customEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 详情 */
- (void)requsetCustomDetailWithBean:(NSString *)bean dataId:(NSString *)dataId taskKey:(NSString *)taskKey processFieldV:(NSNumber *)processFieldV{
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    if (taskKey) {
        [dic setObject:taskKey forKey:@"taskKey"];
    }
    if (processFieldV) {
        [dic setObject:processFieldV forKey:@"processFieldV"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 列表 */
- (void)requsetCustomListWithBean:(NSString *)bean queryWhere:(NSDictionary *)queryWhere menuId:(NSNumber *)menuId pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize seasPoolId:(NSNumber *)seasPoolId fuzzyMatching:(NSString *)fuzzyMatching dataAuth:(NSNumber *)dataAuth menuType:(NSString *)menuType menuCondition:(NSString *)menuCondition{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (dataAuth) {
        [dic setObject:dataAuth forKey:@"dataAuth"];
    }
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (queryWhere) {
        [dic setObject:queryWhere forKey:@"queryWhere"];
    }
    if (menuId) {
        [dic setObject:menuId forKey:@"menuId"];
    }
    if (menuType) {
        [dic setObject:menuType forKey:@"menuType"];
    }
    if (seasPoolId) {
        [dic setObject:seasPoolId forKey:@"seas_pool_id"];
    }
    if (fuzzyMatching) {
        [dic setObject:fuzzyMatching forKey:@"fuzzyMatching"];
    }
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    if (pageNo) {
        [page setObject:pageNo forKey:@"pageNum"];
    }
    if (pageSize) {
        [page setObject:pageSize forKey:@"pageSize"];
    }
    [dic setObject:page forKey:@"pageInfo"];
    
    if (menuCondition) {
        [dic setObject:menuCondition forKey:@"menuCondition"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customDataList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customDataList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 子菜单列表 */
- (void)requsetCustomChildMenuListWithModuleId:(NSNumber *)moduleId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (moduleId) {
        [dic setObject:moduleId forKey:@"moduleId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customChildMenuList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customChildMenuList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 关联搜索 */
- (void)requsetCustomReferenceWithBean:(NSString *)bean relationField:(NSString *)relationField form:(NSDictionary *)form subform:(NSString *)subform pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize reylonForm:(NSDictionary *)reylonForm{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (relationField) {
        [dic setObject:relationField forKey:@"searchField"];
    }
    if (form) {
        [dic setObject:form forKey:@"form"];
    }
    if (reylonForm) {
        [dic setObject:reylonForm forKey:@"reylonForm"];
    }
    if (subform) {
        [dic setObject:subform forKey:@"subform"];
    }
    NSMutableDictionary *pageInfo = [NSMutableDictionary dictionary];
    
    [pageInfo setObject:@(pageSize) forKey:@"pageSize"];
    [pageInfo setObject:@(pageNum) forKey:@"pageNum"];
    
    [dic setObject:pageInfo forKey:@"pageInfo"];
    
    NSString *url = [super urlFromCmd:HQCMD_customRefernceSearch];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customRefernceSearch
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 查重 */
- (void)requsetCustomRecheckingWithBean:(NSString *)bean searchField:(NSString *)searchField keyWord:(NSString *)keyWord searchLabel:(NSString *)searchLabel processId:(NSString *)processId dataId:(NSNumber *)dataId{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (searchField) {
        [dic setObject:searchField forKey:@"field"];
    }
    if (keyWord) {
        [dic setObject:keyWord forKey:@"value"];
    }
    if (searchLabel) {
        [dic setObject:searchLabel forKey:@"label"];
    }
    if (processId) {
        [dic setObject:processId forKey:@"processId"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customChecking];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customChecking
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}


/** 获取筛选字段 */
- (void)requsetCustomFilterFieldsWithBean:(NSString *)bean{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customFilterFields];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customFilterFields
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取业务关联关系列表 */
- (void)requsetCustomReferenceListWithBean:(NSString *)bean dataId:(NSNumber *)dataId{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customRefernceModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customRefernceModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}

/** 获取模块功能权限 */
- (void)requestCustomModuleAuthWithBean:(NSString *)bean{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customModuleAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customModuleAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 转移负责人 */
- (void)requestCustomTransforPrincipalWithDataId:(NSNumber *)dataId bean:(NSString *)bean principalId:(NSArray *)principalId share:(NSNumber *)share{
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"target"];
    }
    if (principalId) {
        [dic setObject:principalId forKey:@"data"];
    }
    if (share) {
        [dic setObject:share forKey:@"share"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customTransferPrincipal];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customTransferPrincipal
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 共享设置列表 */
- (void)requestCustomShareListWithDataId:(NSNumber *)dataId bean:(NSString *)bean{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dic setObject:dataId forKey:@"dataId"];
    }
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customShareList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customShareList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 删除某个共享设置 */
- (void)requestCustomShareDeleteWithDataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customShareDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customShareDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 保存共享设置 */
- (void)requestCustomShareSaveWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_customShareSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customShareSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 编辑共享设置 */
- (void)requestCustomShareEditWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_customShareEdit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customShareEdit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取模块转换列表 */
- (void)requestCustomModuleChangeListWithBean:(NSString *)bean{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customModuleChangeList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customModuleChangeList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 模块转换 */
- (void)requestCustomModuleChangeWithBean:(NSString *)bean dataId:(NSNumber *)dataId ids:(NSArray *)ids{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"dataId"];
    }
    
    if (ids) {
        [dic setObject:ids forKey:@"ids"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customModuleChange];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customModuleChange
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 评论 */
- (void)requestCustomModuleCommentWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_customCommentSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customCommentSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 评论列表 */
- (void)requestCustomModuleCommentListWithBean:(NSString *)bean dataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customCommentList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customCommentList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 动态列表 */
- (void)requestCustomModuleDynamicListWithBean:(NSString *)bean dataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"bean"];
    }
    
    if (dataId) {
        [dic setObject:dataId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_customDynamicList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customDynamicList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 审批列表 type:1 我发起的  2待我审批 3 我已审批 4 抄送到我*/
- (void)requsetApprovalListWithType:(NSNumber *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize querryWhere:(NSDictionary *)querryWhere{
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (type) {
        [dic setObject:type forKey:@"type"];
    }
    
    if (pageNum) {
        [dic setObject:pageNum forKey:@"pageNum"];
    }
    
    if (pageSize) {
        [dic setObject:pageSize forKey:@"pageSize"];
    }
    
    // sign:2 带条件 3：不带条件
    if (querryWhere) {
        [dic setObject:querryWhere forKey:@"queryWhere"];
        
        [dic setObject:@2 forKey:@"sign"];
        
    }else{
        
        [dic setObject:@3 forKey:@"sign"];
        
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_customApprovalList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 查询筛选条件 */
-(void)requestCustomApprovalSearchMenuWithType:(NSNumber *)type{
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (type) {
        [dic setObject:type forKey:@"type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalSearchMenu];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customApprovalSearchMenu
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 查询某模块下的审批数据 */
-(void)requestGetApprovalWithBean:(NSString *)bean keyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize{
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dic setObject:bean forKey:@"moduleBean"];
    }
    
    if (pageNum) {
        [dic setObject:pageNum forKey:@"pageNum"];
    }
    
    if (pageSize) {
        [dic setObject:pageSize forKey:@"pageSize"];
    }
    
    if (keyword) {
        [dic setObject:keyword forKey:@"keyWord"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getApprovalListWithBean];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_getApprovalListWithBean
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];

}

/** 获取审批流程 */
- (void)requsetApprovalWholeFlowWithProcessDefinitionId:(NSString *)processDefinitionId bean:(NSString *)bean dataId:(NSString *)dataId{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (processDefinitionId) {
        [dic setObject:processDefinitionId forKey:@"processInstanceId"];
    }
    if (bean) {
        [dic setObject:bean forKey:@"moduleBean"];
    }
    if (dataId) {
        [dic setObject:dataId forKey:@"dataId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalWholeFlow];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_customApprovalWholeFlow
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 审批通过 */
- (void)requestApprovalPassWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalPass];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalPass
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批驳回 */
- (void)requestApprovalRejectWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalReject];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalReject
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批转交 */
- (void)requestApprovalTransferWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalTransfer];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalTransfer
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 审批撤销 */
- (void)requestApprovalCancelWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalRevoke];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalRevoke
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批抄送 */
- (void)requestApprovalCopyWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalCopy];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalCopy
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批催办 */
- (void)requestApprovalFastWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalUrge];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalUrge
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 审批已读 */
- (void)requestApprovalCopyReadWithProcessDefinitionId:(NSString *)processDefinitionId type:(NSNumber *)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (processDefinitionId) {
        [dict setObject:processDefinitionId forKey:@"process_definition_id"];
    }
    if (type) {
        [dict setObject:type forKey:@"type"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalRead];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalRead
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 待审批及抄送数量 */
- (void)requestApprovalCount{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalCount];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalCount
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 驳回方式 */
- (void)requestApprovalRejectTypeWithBean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"moduleBean"];
    }
    if (processInstanceId) {
        [dict setObject:processInstanceId forKey:@"processInstanceId"];
    }
    if (taskKey) {
        [dict setObject:taskKey forKey:@"taskKey"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalRejectType];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalRejectType
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    

}

/** 通过方式 */
- (void)requestApprovalPassTypeWithBean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey taskId:()taskId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"moduleBean"];
    }
    if (processInstanceId) {
        [dict setObject:processInstanceId forKey:@"processInstanceId"];
    }
    if (taskKey) {
        [dict setObject:taskKey forKey:@"taskKey"];
    }
    if (taskId) {
        [dict setObject:taskId forKey:@"taskId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customApprovalPassType];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_customApprovalPassType
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}


/** 删除审批 */
- (void)requestApprovalDeleteWithBean:(NSString *)bean dataId:(NSString *)dataId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"moduleBean"];
    }
    
    if (dataId) {
        [dict setObject:dataId forKey:@"moduleDataId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_customRemoveProcessApproval];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customRemoveProcessApproval
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 公海池领取 */
- (void)requestHighseaTakeWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (seasPoolId) {
        [dict setObject:seasPoolId forKey:@"seas_pool_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_highseaTake];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_highseaTake
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 公海池移动 */
- (void)requestHighseaMoveWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (seasPoolId) {
        [dict setObject:seasPoolId forKey:@"seas_pool_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_highseaMove];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_highseaMove
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 公海池退回 */
- (void)requestHighseaBackWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (seasPoolId) {
        [dict setObject:seasPoolId forKey:@"seas_pool_id"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_highseaBack];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_highseaBack
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 公海池分配 */
- (void)requestHighseaAllocateWithDataId:(NSNumber *)dataId bean:(NSString *)bean employeeId:(NSNumber *)employeeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (employeeId) {
        [dict setObject:employeeId forKey:@"employee_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_highseaAllocate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_highseaAllocate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 公海池列表 */
- (void)requestHighseaListWithBean:(NSString *)bean{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_highseaList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_highseaList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取统计报表列表 */
- (void)requestStatisticsListWithMenuId:(NSString *)menuId styleType:(NSString *)styleType reportLabel:(NSString *)reportLabel dataSourceName:(NSString *)dataSourceName createBy:(NSString *)createBy createTime:(NSString *)createTime modifyBy:(NSString *)modifyBy modifyTime:(NSString *)modifyTime{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (menuId) {
        [dict setObject:menuId forKey:@"menuId"];
    }
    if (styleType) {
        [dict setObject:styleType forKey:@"styleType"];
    }
    
    if (reportLabel) {
        [dict setObject:reportLabel forKey:@"reportLabel"];
    }
    if (dataSourceName) {
        [dict setObject:dataSourceName forKey:@"dataSourceName"];
    }
    if (createBy) {
        [dict setObject:createBy forKey:@"createBy"];
    }
    if (createTime) {
        [dict setObject:createTime forKey:@"createTime"];
    }
    if (modifyBy) {
        [dict setObject:modifyBy forKey:@"modifyBy"];
    }
    if (modifyTime) {
        [dict setObject:modifyTime forKey:@"modifyTime"];
    }

    NSString *url = [super urlFromCmd:HQCMD_getReportList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getReportList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 报表筛选字段 */
- (void)requestGetFilterFields{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_getReportFilterFields];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getReportFilterFields
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 报表筛选字段 */
- (void)requestGetFilterFieldsWithReportId:(NSNumber *)reportId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (reportId) {
        [dict setObject:reportId forKey:@"reportId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getReportFilterFieldsWithReportId];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getReportFilterFieldsWithReportId
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 报表布局 */
- (void)requestGetReportLayoutDetailWithReportId:(NSNumber *)reportId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (reportId) {
        [dict setObject:reportId forKey:@"reportId"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getReportLayoutDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getReportLayoutDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 报表详情 */
- (void)requestGetReportDetailWithReportDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_getReportDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getReportDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 仪表详情 */
- (void)requestGetChartDetailWithChartId:(NSNumber *)chartId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (chartId) {
        [dict setObject:chartId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getChartDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getChartDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取chart列表 */
- (void)requestChartList{
    
    NSString *url = [super urlFromCmd:HQCMD_getChartList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getChartList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 是否需要选择下一审批人（邮件） */
- (void)requestGetCustomApprovalCheckChooseNextApproval {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"mail_box_scope" forKey:@"moduleBean"];
    
    NSString *url = [super urlFromCmd:HQCMD_CustomApprovalCheckChooseNextApproval];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_CustomApprovalCheckChooseNextApproval
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取审批详情参数（审批小助手） */
- (void)requestQueryApprovalDataWithDataId:(NSNumber *)dataId type:(NSNumber *)type bean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dataId) {
        [dict setObject:dataId forKey:@"dataId"];
    }
    if (type) {
        [dict setObject:type forKey:@"type"];
    }
    if (bean) {
        
        [dict setObject:bean forKey:@"moduleBean"];
    }
    if (taskKey) {
        
        [dict setObject:taskKey forKey:@"taskKey"];
    }
    if (processInstanceId) {
        
        [dict setObject:processInstanceId forKey:@"processInstanceId"];
    }
    NSString *url = [super urlFromCmd:HQCMD_CustomQueryApprovalData];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_CustomQueryApprovalData
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取所有应用 */
- (void)requestAllApplication{
    
    NSString *url = [super urlFromCmd:HQCMD_allApplications];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_allApplications
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 获取应用下的模块 */
- (void)requestModuleWithApplicationId:(NSNumber *)applicationId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (applicationId) {
        [dict setObject:applicationId forKey:@"application_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_allModules];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_allModules
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 判断模块是否有新建权限 */
- (void)requestHaveAuthWithModuleId:(NSNumber *)moduleId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (moduleId) {
        [dict setObject:moduleId forKey:@"module_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moduleHaveAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_moduleHaveAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 判断模块是否有阅读权限 */
- (void)requestHaveReadAuthWithModuleBean:(NSString *)bean withDataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (dataId) {
        [dict setObject:dataId forKey:@"dataId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_moduleHaveReadAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_moduleHaveReadAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取自定义选择范围人员 */
- (void)requestCustomRangePeopleWithRangePeople:(NSArray *)rangePeople{
    
    
    NSString *url = [super urlFromCmd:HQCMD_customRangePeople];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (rangePeople) {
        [dict setObject:rangePeople forKey:@"chooseRange"];
    }
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_customRangePeople
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 快速新增 */
-(void)requestQuickAdd{
    
    NSString *url = [super urlFromCmd:HQCMD_quickAdd];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_quickAdd
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 生成条形码 */
-(void)requestCreateBarcodeWithBarcodeType:(NSString *)barcodeType barcodeValue:(NSString *)barcodeValue{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(barcodeType)) {
        [dict setObject:barcodeType forKey:@"barcodeType"];
    }
    if (!IsStrEmpty(barcodeValue)) {
        [dict setObject:barcodeValue forKey:@"barcodeValue"];
    }
    NSString *url = [super urlFromCmd:HQCMD_createBarcode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_createBarcode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 条形码获取详情 */
-(void)requestBarcodeDetailWithBarcodeValue:(NSString *)barcodeValue{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(barcodeValue)) {
        [dict setObject:barcodeValue forKey:@"barcodeValue"];
    }
    NSString *url = [super urlFromCmd:HQCMD_barcodeDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_barcodeDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 条形码图片 */
-(void)requestBarcodePictureWithBean:(NSString *)bean barcodeValue:(NSString *)barcodeValue{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(bean)) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (!IsStrEmpty(barcodeValue)) {
        [dict setObject:barcodeValue forKey:@"barcodeValue"];
    }
    NSString *url = [super urlFromCmd:HQCMD_barcodePicture];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_barcodePicture
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取某模块数据条件字段列表 */
-(void)requestGetConditionFieldListWithBean:(NSString *)bean{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(bean)) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getCustomConditionField];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getCustomConditionField
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 条件字段value变更触发获取联动字段列表和value */
-(void)requestGetLinkageFieldListWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_getLinkageFieldList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getLinkageFieldList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取固定模块 */
-(void)requestGetSystemStableModule{
    
    NSString *url = [super urlFromCmd:HQCMD_getSystemStableModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getSystemStableModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}
/** 获取固定模块(有权限) */
-(void)requestGetAuthSystemStableModule{
    
    NSString *url = [super urlFromCmd:HQCMD_getSystemStableModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:@{@"type":@1}
                                            cmdId:HQCMD_getSystemStableModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取某模块自动匹配模块列表 */
-(void)requestAutoMatchModuleWithBean:(NSString *)bean{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(bean)) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getAutoMatchModuleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAutoMatchModuleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取自动匹配模块数据列表 */
-(void)requestAutoMatchModuleDataListWithDataId:(NSNumber *)dataId sorceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean pageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum ruleId:(NSNumber *)ruleId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"dataId"];
    }
    if (!IsStrEmpty(sorceBean)) {
        [dict setObject:sorceBean forKey:@"sorceBean"];
    }
    if (!IsStrEmpty(targetBean)) {
        [dict setObject:targetBean forKey:@"targetBean"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (ruleId) {
        [dict setObject:ruleId forKey:@"ruleId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getAutoMatchModuleDataList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAutoMatchModuleDataList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取某模块的匹配规则列表 */
-(void)requsetAutoMatchRuleListWithSourceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(sorceBean)) {
        [dict setObject:sorceBean forKey:@"sorceBean"];
    }
    if (!IsStrEmpty(targetBean)) {
        [dict setObject:targetBean forKey:@"targetBean"];
    }
    NSString *url = [super urlFromCmd:HQCMD_getAutoMatchModuleRuleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAutoMatchModuleRuleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
    
}

/** 获取规则下的匹配到的数据列表 */
-(void)requestAutoMatchRuleDataListWithDataId:(NSNumber *)dataId ruleId:(NSNumber *)ruleId bean:(NSString *)bean pageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (!IsStrEmpty(bean)) {
        [dict setObject:bean forKey:@"bean"];
    }
    if (ruleId) {
        [dict setObject:ruleId forKey:@"ruleId"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getAutoMatchModuleRuleDataList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getAutoMatchModuleRuleDataList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取页签列表 */
-(void)requestTabListWithBean:(NSString *)bean dataId:(NSNumber *)dataId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"dataId"];
    }
    if (!IsStrEmpty(bean)) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getTabList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getTabList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取页签下的数据列表 */
-(void)requestTabDataWithTabId:(NSNumber *)tabId dataAuth:(NSNumber *)dataAuth dataId:(NSNumber *)dataId ruleId:(NSNumber *)ruleId moduleId:(NSNumber *)moduleId dataType:(NSNumber *)dataType pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dataId) {
        [dict setObject:dataId forKey:@"id"];
    }
    if (tabId) {
        [dict setObject:tabId forKey:@"tabId"];
    }
    if (moduleId) {
        [dict setObject:moduleId forKey:@"moduleId"];
    }
    if (dataAuth) {
        [dict setObject:dataAuth forKey:@"dataAuth"];
    }
    if (dataType) {
        [dict setObject:dataType forKey:@"type"];
    }
    if (ruleId) {
        [dict setObject:ruleId forKey:@"ruleId"];
    }
    if (pageSize) {
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    if (pageNum) {
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getTabDataList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getTabDataList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取关联页签下新建获取关联映射字段值 */
-(void)requestReferanceReflectWithSorceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean detailJson:(NSString *)detailJson{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(sorceBean)) {
        [dict setObject:sorceBean forKey:@"sorceBean"];
    }
    if (!IsStrEmpty(targetBean)) {
        [dict setObject:targetBean forKey:@"targetBean"];
    }
    if (detailJson) {
        [dict setObject:detailJson forKey:@"detailJson"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getReferanceReflect];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_getReferanceReflect
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 获取web链接列表 */
-(void)requestWebLinkListWithModuleBean:(NSString *)moduleBean source:(NSNumber *)source seasPoolId:(NSNumber *)seasPoolId relevanceModule:(NSString *)relevanceModule relevanceField:(NSString *)relevanceField relevanceValue:(NSString *)relevanceValue{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (!IsStrEmpty(moduleBean)) {
        [dict setObject:moduleBean forKey:@"moduleBean"];
    }
    if (!IsStrEmpty(relevanceModule)) {
        [dict setObject:relevanceModule forKey:@"relevanceModule"];
    }
    if (relevanceField) {
        [dict setObject:relevanceField forKey:@"relevanceField"];
    }
    if (relevanceValue) {
        [dict setObject:relevanceValue forKey:@"relevanceValue"];
    }
    if (source) {
        [dict setObject:source forKey:@"source"];
    }
    
    if (seasPoolId) {
        [dict setObject:seasPoolId forKey:@"seasPoolId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getWebLinkList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getWebLinkList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 获取显示模块 */
-(void)requestWorkEnterShowModule{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@1 forKey:@"type"];
    NSString *url = [super urlFromCmd:HQCMD_workEnterShow];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_workEnterShow
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 获取所有模块 */
-(void)requestAllModule{
    
    NSString *url = [super urlFromCmd:HQCMD_workEnterAllModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_workEnterAllModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 保存常用模块 */
- (void)requestSaveOftenModules:(NSArray *)modules{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (modules) {
        [dict setObject:modules forKey:@"data"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_saveOftenModule];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveOftenModule
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 子表选项关联 */
-(void)requestSubformRalationWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_subformRelation];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_subformRelation
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 简历解析上传 */
-(void)requestResumeWithBean:(NSString *)bean files:(NSArray *)files{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    
    NSString *url = [self urlFromCmd:HQCMD_resumeFile];
    
    HQRequestItem *requestItem = [RM uploadPicToURL:url
                                       requestParam:dict
                                           imgDatas:files
                                         audioDatas:nil
                                         videoDatas:nil
                                              cmdId:HQCMD_resumeFile
                                           delegate:self
                                         startBlock:^(HQCMD cmd, NSInteger sid) {}];
    
    [self.tasks addObject:requestItem];
    
}


#pragma mark - Response
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
                
            case HQCMD_uploadFile:// 上传文件
            {
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFFileModel *model = [[TFFileModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
            case HQCMD_ChatFile:// 上传文件
            {
                NSArray *files = data[kData];
                
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in files) {
                    
                    TFFileModel *model = [[TFFileModel alloc] initWithDictionary:dict error:nil];
                    
                    [array addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_customLayout:
            case HQCMD_customTaskLayout:
            {
                NSDictionary *dict = data[kData];
                NSError *error;
                TFCustomBaseModel *model = [[TFCustomBaseModel alloc] initWithDictionary:dict error:&error];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model data:dict];
            }
                break;
            case HQCMD_saveTaskLayoutData:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_savePersonnelData:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
                case HQCMD_customApplicationList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *applications = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFApplicationModel *model = [[TFApplicationModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [applications addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:applications];
                
            }
                break;
            case HQCMD_customSave:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customDelete:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customEdit:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customDetail:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customDataList:
            {
                NSDictionary *dict = data[kData];
                TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
                for (TFCustomListItemModel *item  in model.dataList) {
                    for (TFFieldNameModel *field in item.row.row1) {
                        if ([model.seasPwdFields containsString:field.name]) {
                            field.secret = @"1";
                        }
                    }
                    for (TFFieldNameModel *field in item.row.row2) {
                        if ([model.seasPwdFields containsString:field.name]) {
                            field.secret = @"1";
                        }
                    }
                    for (TFFieldNameModel *field in item.row.row3) {
                        if ([model.seasPwdFields containsString:field.name]) {
                            field.secret = @"1";
                        }
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_customChildMenuList:
            {
                NSMutableArray *arr = [NSMutableArray array];
                NSDictionary *dataDict = data[kData];
                [arr addObjectsFromArray:[dataDict valueForKey:@"defaultSubmenu"]];
                [arr addObjectsFromArray:[dataDict valueForKey:@"newSubmenu"]];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFBeanTypeModel *model = [[TFBeanTypeModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customRefernceSearch:
            {
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFReferenceListModel *model = [[TFReferenceListModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        model.relationField = [dict valueForKey:@"relationField"];
                        [models addObject:model];
                    }
                }
                NSDictionary *page = [dd valueForKey:@"pageInfo"];
                TFCustomPageModel *pageModel = [[TFCustomPageModel alloc] initWithDictionary:page error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models data:pageModel];
            }
                break;
            case HQCMD_customFilterFields:
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFilterModel *model = [[TFFilterModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        if ([dict valueForKey:@"entrys"]) {
                            model.options = [dict valueForKey:@"entrys"];
                        }
                        if ([dict valueForKey:@"member"]) {
                            model.options = [dict valueForKey:@"member"];
                        }
                        [models addObject:model];
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customRefernceModule:
            {
                NSDictionary *dict = data[kData];
                TFCustomDetailRefrenceModel *model = [[TFCustomDetailRefrenceModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_customModuleAuth:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFCustomAuthModel *model = [[TFCustomAuthModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_customTransferPrincipal:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customShareList:
            {
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_customShareDelete:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customShareSave:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customShareEdit:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customModuleChangeList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFCustomChangeModel *model = [[TFCustomChangeModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customModuleChange:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customCommentSave:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customCommentList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                
                for (NSDictionary *dict in arr) {
                    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
                    model.employee_name = [dict valueForKey:@"employee_name"];
                    model.employee_id = [dict valueForKey:@"employee_id"];
                    model.datetime_time = [dict valueForKey:@"datetime_time"];
                    model.bean = [dict valueForKey:@"bean"];
                    model.relation_id = [dict valueForKey:@"relation_id"];
                    model.content = [dict valueForKey:@"content"];
                    model.picture = [dict valueForKey:@"picture"];
                    
                    /** 动态类型 0:聊天 1：语音 2：图片 3：文件 */
                    id obj = [dict valueForKey:@"information"];
                    if ([obj isKindOfClass:[NSString class]]) {
                        model.type = @0;
                    }
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        if ([[obj valueForKey:@"file_type"] isEqualToString:@"jpg"] || [[obj valueForKey:@"file_type"] isEqualToString:@"png"] || [[obj valueForKey:@"file_type"] isEqualToString:@"gif"] || [[obj valueForKey:@"file_type"] isEqualToString:@"jpeg"]) {
                            
                            model.type = @2;
                            model.fileUrl = [obj valueForKey:@"file_url"];
                            model.fileName = [obj valueForKey:@"file_name"];
                            model.fileSize = [obj valueForKey:@"file_size"];
                            model.fileType = [obj valueForKey:@"file_type"];
                        }else if ([[obj valueForKey:@"file_type"] isEqualToString:@"mp3"] || [[obj valueForKey:@"file_type"] isEqualToString:@"arm"]) {
                            
                            model.type = @1;
                            model.fileUrl = [obj valueForKey:@"file_url"];
                            model.fileName = [obj valueForKey:@"file_name"];
                            model.fileSize = [obj valueForKey:@"file_size"];
                            model.fileType = [obj valueForKey:@"file_type"];
                            model.voiceTime = [obj valueForKey:@"voiceTime"];
                        }else{
                            
                            model.type = @3;
                            model.fileUrl = [obj valueForKey:@"file_url"];
                            model.fileName = [obj valueForKey:@"file_name"];
                            model.fileSize = [obj valueForKey:@"file_size"];
                            model.fileType = [obj valueForKey:@"file_type"];
                        }
                    }
                    if ([obj isKindOfClass:[NSArray class]]) {
                        
                        NSArray *aa = (NSArray *)obj;
                        
                        if (aa.count) {
                            NSDictionary *obj1 = aa[0];
                            
                            if ([[obj1 valueForKey:@"file_type"] isEqualToString:@"jpg"] || [[obj1 valueForKey:@"file_type"] isEqualToString:@"png"] || [[obj1 valueForKey:@"file_type"] isEqualToString:@"gif"] || [[obj1 valueForKey:@"file_type"] isEqualToString:@"jpeg"]) {
                                
                                model.type = @2;
                                model.fileUrl = [obj1 valueForKey:@"file_url"];
                                model.fileName = [obj1 valueForKey:@"file_name"];
                                model.fileSize = [obj1 valueForKey:@"file_size"];
                                model.fileType = [obj1 valueForKey:@"file_type"];
                            }else if ([[obj1 valueForKey:@"file_type"] isEqualToString:@"mp3"] || [[obj1 valueForKey:@"file_type"] isEqualToString:@"arm"]) {
                                
                                model.type = @1;
                                model.fileUrl = [obj1 valueForKey:@"file_url"];
                                model.fileName = [obj1 valueForKey:@"file_name"];
                                model.fileSize = [obj1 valueForKey:@"file_size"];
                                model.fileType = [obj1 valueForKey:@"file_type"];
                                model.voiceTime = [obj1 valueForKey:@"voiceTime"];
                            }else{
                                
                                model.type = @3;
                                model.fileUrl = [obj1 valueForKey:@"file_url"];
                                model.fileName = [obj1 valueForKey:@"file_name"];
                                model.fileSize = [obj1 valueForKey:@"file_size"];
                                model.fileType = [obj1 valueForKey:@"file_type"];
                            }

                        }
                    
                    }
                    
                    [models addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customDynamicList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFCustomerDynamicModel *model = [[TFCustomerDynamicModel alloc] initWithDictionary:dict error:nil];
                    [models addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_customApprovalList:
            case HQCMD_getApprovalListWithBean:
            {
                
                NSDictionary *mo = data[kData];
                
                TFApprovalListModel *model = [[TFApprovalListModel alloc] initWithDictionary:mo error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_customApprovalSearchMenu:
            {
                
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFilterModel *model = [[TFFilterModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                        model.options = [dict valueForKey:@"entrys"]?[dict valueForKey:@"entrys"]:[dict valueForKey:@"member"];
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_customApprovalWholeFlow:
            {
                
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    NSError *errer;
                    TFApprovalFlowModel *model = [[TFApprovalFlowModel alloc] initWithDictionary:dict error:&errer];
                    NSMutableArray<Ignore,TFFileModel>  *ss = [NSMutableArray<Ignore,TFFileModel>  array];
                    if ([@"" isEqualToString:[dict valueForKey:@"approval_signature"]]) {
                        model.approval_signature = ss;
                    }else{
                        NSArray *aa = [dict valueForKey:@"approval_signature"];
                        for (NSDictionary *dd in aa) {
                            TFFileModel *file = [[TFFileModel alloc] initWithDictionary:dd error:nil];
                            if (file) {
                                [ss addObject:file];
                            }
                        }
                        model.approval_signature = ss;
                        
                    }
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customApprovalPass:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalReject:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalTransfer:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalRevoke:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalCopy:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalUrge:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalRead:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_customApprovalCount:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_customApprovalRejectType:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_customApprovalPassType:
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_customRemoveProcessApproval:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_highseaTake:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_highseaMove:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_highseaBack:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_highseaAllocate:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_highseaList:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *di in arr) {
                    
                    TFHighseaModel *model = [[TFHighseaModel alloc] initWithDictionary:di error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                    
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customChecking:// 查重
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFReferenceListModel *model = [[TFReferenceListModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
//                        NSMutableArray <Optional,TFFieldNameModel>*kk = [NSMutableArray<Optional,TFFieldNameModel> array];
//                        TFFieldNameModel *fi = [[TFFieldNameModel alloc] init];
//                        [kk addObject:fi];
//                        [kk addObjectsFromArray:model.row];
//                        model.row = kk;
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_customApplicationOften:
            {
                
                NSDictionary *dict = data[kData];
                TFStatisticsListModel *model = [[TFStatisticsListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_getReportList:
            {
                NSDictionary *dict = data[kData];
                TFStatisticsListModel *model = [[TFStatisticsListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                case HQCMD_getReportFilterFields:
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFilterModel *model = [[TFFilterModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                        if ([dict valueForKey:@"entrys"]) {
                            model.options = [dict valueForKey:@"entrys"];
                        }
                        if ([dict valueForKey:@"member"]) {
                            model.options = [dict valueForKey:@"member"];
                        }
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getReportFilterFieldsWithReportId:
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFFilterModel *model = [[TFFilterModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                        if ([dict valueForKey:@"entrys"]) {
                            model.options = [dict valueForKey:@"entrys"];
                        }
                        if ([dict valueForKey:@"member"]) {
                            model.options = [dict valueForKey:@"member"];
                        }
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getReportDetail:
            {
                NSString *str = [HQHelper dictionaryToJson:data[kData]];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
            }
                break;
            case HQCMD_getChartDetail:
            {
                NSString *str = [HQHelper dictionaryToJson:data[kData]];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
            }
                break;
            case HQCMD_getReportLayoutDetail:
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
            }
                break;
            case HQCMD_getChartList:
            {
                NSDictionary *dict = data;
                TFStatisticsListModel *model = [[TFStatisticsListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_CustomApprovalCheckChooseNextApproval: //是否需要选择下一个审批人（邮件）
            {
                NSDictionary *dict = data[kData];
                TFEmialApproverModel *model = [[TFEmialApproverModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_CustomQueryApprovalData: //获取审批详情参数（审批小助手）
            {
                NSDictionary *dict = data[kData];
                TFApprovalListItemModel *model = [[TFApprovalListItemModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_allApplications: //获取应用
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_allModules: //获取应用的模块
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_saveOftenModule: // 保存常用
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_moduleHaveAuth: // 模块新建权限
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_moduleHaveReadAuth: // 模块阅读权限
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_customRangePeople: // 自定义人员范围
            {
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_quickAdd: // 快速新增
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFModuleModel *model = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_createBarcode: // 生成条形码
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_barcodeDetail: // 条形码详情
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_barcodePicture: // 条形码图片
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getCustomConditionField: // 获取某模块数据条件字段列表
            {
                NSArray *arr = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
            }
                break;
            case HQCMD_getLinkageFieldList: // 条件字段value变更触发获取联动字段列表和value
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getSystemStableModule: // 获取系统固定模块
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getAutoMatchModuleList: // 获取自动匹配模块列表
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dd in arr) {
                    TFRelevanceTradeModel *model = [[TFRelevanceTradeModel alloc] initWithDictionary:dd error:nil];
                    if (model) {
                        model.isAuto = @1;
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getAutoMatchModuleDataList: // 获取自动匹配模块数据列表
            {
                NSDictionary *dict = data[kData];
                TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_getAutoMatchModuleRuleList: // 获取自动匹配模块规则列表
            {
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFAutoMatchRuleModel *model = [[TFAutoMatchRuleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getAutoMatchModuleRuleDataList: // 获取自动匹配模块规则下的数据列表
            {
                NSDictionary *dict = data[kData];
                TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_getTabList: // 获取页签列表
            {
                NSDictionary *dict = data[kData];
                TFCustomDetailRefrenceModel *model = [[TFCustomDetailRefrenceModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_getTabDataList: // 获取页签下的数据列表
            {
                NSDictionary *dict = data[kData];
//                TFCustomListModel *model = [[TFCustomListModel alloc] initWithDictionary:dict error:nil];
//                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getReferanceReflect:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getWebLinkList:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_workEnterShow:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFModuleModel *model = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models data:arr];
            }
                break;
            case HQCMD_workEnterAllModule:
            {
                NSArray *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFModuleModel *model = [[TFModuleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_subformRelation:
            {
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFReferenceListModel *model = [[TFReferenceListModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        model.relationField = [dict valueForKey:@"relationField"];
                        [models addObject:model];
                    }
                }
                NSDictionary *page = [dd valueForKey:@"pageInfo"];
                TFCustomPageModel *pageModel = [[TFCustomPageModel alloc] initWithDictionary:page error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models data:pageModel];
            }
                break;
            case HQCMD_resumeFile:
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
                
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
    
}


- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithProgress:(NSProgress *)progress cmdId:(HQCMD)cmdId{
    
    HQResponseEntity *resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid progress:progress];
    [super progressCallbackWithResponse:resp];
}


@end
