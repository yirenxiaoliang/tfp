//
//  TFCustomBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQBaseBL.h"

@interface TFCustomBL : HQBaseBL

/** 获取布局
 *
 *  @prama bean 模块bean
 *  @prama taskKey
 *  @prama operationType  1:自定义表单 2:新增 3:编辑 4:详情
 *  @param dataId 某条数据id(详情时数据id)
 *  @param processFieldV 流程字段版本
 *  @param isSeasPool 是否为公海池
 */
- (void)requestCustomLayoutWithBean:(NSString *)bean taskKey:(NSString *)taskKey operationType:(NSNumber *)operationType dataId:(NSString *)dataId isSeasPool:(NSString *)isSeasPool processFieldV:(NSNumber *)processFieldV;
/** 获取任务布局（项目任务和个人任务，以bean区分）
 项目任务的自定义：bean:  project_custom_ + 项目ID
 个人任务的自定义 bean : project_custom
 */
-(void)requestTaskLayoutWithBean:(NSString *)bean;
/** 保存项目任务数据 */
-(void)requestSaveTaskLayoutDataWithData:(NSDictionary *)dict;
/** 保存个人任务数据 */
-(void)requestSavePersonnelDataWithData:(NSDictionary *)dict;
/** 获取自定义应用列表 */
- (void)requestCustomApplicationListWithApprovalFlag:(NSString *)approvalFlag;
/** 编辑常用模块列表 */
- (void)requestCustomOftenApplicationListWithModules:(NSArray *)modules;
/** 新增保存 */
- (void)requsetCustomSaveWithDictData:(NSDictionary *)dictData;
/** 删除 */
- (void)requsetCustomDeleteWithBean:(NSString *)bean dataId:(NSNumber *)dataId subformFields:(NSString *)subformFields;
/** 编辑保存 */
- (void)requsetCustomEditWithDictData:(NSDictionary *)dictData;
/** 详情 */
- (void)requsetCustomDetailWithBean:(NSString *)bean dataId:(NSString *)dataId taskKey:(NSString *)taskKey processFieldV:(NSNumber *)processFieldV;
/** 列表 */
- (void)requsetCustomListWithBean:(NSString *)bean queryWhere:(NSDictionary *)queryWhere menuId:(NSNumber *)menuId pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize seasPoolId:(NSNumber *)seasPoolId fuzzyMatching:(NSString *)fuzzyMatching dataAuth:(NSNumber *)dataAuth menuType:(NSString *)menuType menuCondition:(NSString *)menuCondition;
/** 子菜单列表 */
- (void)requsetCustomChildMenuListWithModuleId:(NSNumber *)moduleId;
/** 关联搜索 */
- (void)requsetCustomReferenceWithBean:(NSString *)bean relationField:(NSString *)relationField form:(NSDictionary *)form subform:(NSString *)subform pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize reylonForm:(NSDictionary *)reylonForm;
/** 查重 */
- (void)requsetCustomRecheckingWithBean:(NSString *)bean searchField:(NSString *)searchField keyWord:(NSString *)keyWord searchLabel:(NSString *)searchLabel processId:(NSString *)processId dataId:(NSNumber *)dataId;
/** 获取筛选字段 */
- (void)requsetCustomFilterFieldsWithBean:(NSString *)bean;
/** 获取业务关联关系列表 */
- (void)requsetCustomReferenceListWithBean:(NSString *)bean dataId:(NSNumber *)dataId;
/** 获取模块功能权限 */
- (void)requestCustomModuleAuthWithBean:(NSString *)bean;
/** 转移负责人 */
- (void)requestCustomTransforPrincipalWithDataId:(NSNumber *)dataId bean:(NSString *)bean principalId:(NSArray *)principalId share:(NSNumber *)share;
/** 共享设置列表 */
- (void)requestCustomShareListWithDataId:(NSNumber *)dataId bean:(NSString *)bean;
/** 删除某个共享设置 */
- (void)requestCustomShareDeleteWithDataId:(NSNumber *)dataId;
/** 保存共享设置 */
- (void)requestCustomShareSaveWithDict:(NSDictionary *)dict;
/** 编辑共享设置 */
- (void)requestCustomShareEditWithDict:(NSDictionary *)dict;
/** 获取模块转换列表 */
- (void)requestCustomModuleChangeListWithBean:(NSString *)bean;
/** 模块转换 */
- (void)requestCustomModuleChangeWithBean:(NSString *)bean dataId:(NSNumber *)dataId ids:(NSArray *)ids;
/** 评论 */
- (void)requestCustomModuleCommentWithDict:(NSDictionary *)dict;
/** 评论列表 */
- (void)requestCustomModuleCommentListWithBean:(NSString *)bean dataId:(NSNumber *)dataId;
/** 动态列表 */
- (void)requestCustomModuleDynamicListWithBean:(NSString *)bean dataId:(NSNumber *)dataId;
/** 审批列表 type:1 我发起的  2待我审批 3 我已审批 4 抄送到我*/
- (void)requsetApprovalListWithType:(NSNumber *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize querryWhere:(NSDictionary *)querryWhere;
/** 获取审批流程 */
- (void)requsetApprovalWholeFlowWithProcessDefinitionId:(NSString *)processDefinitionId bean:(NSString *)bean dataId:(NSString *)dataId;
/** 查询筛选条件 */
-(void)requestCustomApprovalSearchMenuWithType:(NSNumber *)type;
/** 查询某模块下的审批数据 */
-(void)requestGetApprovalWithBean:(NSString *)bean keyword:(NSString *)keyword pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;
/** 审批通过 */
- (void)requestApprovalPassWithDict:(NSDictionary *)dict;
/** 审批驳回 */
- (void)requestApprovalRejectWithDict:(NSDictionary *)dict;
/** 审批转交 */
- (void)requestApprovalTransferWithDict:(NSDictionary *)dict;
/** 审批撤销 */
- (void)requestApprovalCancelWithDict:(NSDictionary *)dict;
/** 审批抄送 */
- (void)requestApprovalCopyWithDict:(NSDictionary *)dict;
/** 审批催办 */
- (void)requestApprovalFastWithDict:(NSDictionary *)dict;
/** 审批已读 1:待我审批 3：抄送到我 */
- (void)requestApprovalCopyReadWithProcessDefinitionId:(NSString *)processDefinitionId type:(NSNumber *)type;
/** 待审批及抄送数量 */
- (void)requestApprovalCount;
/** 驳回方式 */
- (void)requestApprovalRejectTypeWithBean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey;
/** 通过方式 */
- (void)requestApprovalPassTypeWithBean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey taskId:()taskId;
/** 删除审批 */
- (void)requestApprovalDeleteWithBean:(NSString *)bean dataId:(NSString *)dataId;
/** 公海池领取 */
- (void)requestHighseaTakeWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId;
/** 公海池移动 */
- (void)requestHighseaMoveWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId;
/** 公海池退回 */
- (void)requestHighseaBackWithDataId:(NSNumber *)dataId bean:(NSString *)bean seasPoolId:(NSNumber *)seasPoolId;
/** 公海池分配 */
- (void)requestHighseaAllocateWithDataId:(NSNumber *)dataId bean:(NSString *)bean employeeId:(NSNumber *)employeeId;
/** 公海池列表 */
- (void)requestHighseaListWithBean:(NSString *)bean;
/** 获取统计报表列表 */
- (void)requestStatisticsListWithMenuId:(NSString *)menuId styleType:(NSString *)styleType reportLabel:(NSString *)reportLabel dataSourceName:(NSString *)dataSourceName createBy:(NSString *)createBy createTime:(NSString *)createTime modifyBy:(NSString *)modifyBy modifyTime:(NSString *)modifyTime;
/** 报表筛选字段 */
- (void)requestGetFilterFields;
/** 报表筛选字段 */
- (void)requestGetFilterFieldsWithReportId:(NSNumber *)reportId;
/** 报表布局 */
- (void)requestGetReportLayoutDetailWithReportId:(NSNumber *)reportId;
/** 报表详情 */
- (void)requestGetReportDetailWithReportDict:(NSDictionary *)dict;
/** 仪表详情 */
- (void)requestGetChartDetailWithChartId:(NSNumber *)chartId;
/** 是否需要选择下一审批人（邮件） */
- (void)requestGetCustomApprovalCheckChooseNextApproval;
/** 获取审批详情参数（审批小助手） */
//- (void)requestQueryApprovalDataWithDataId:(NSNumber *)dataId type:(NSNumber *)type;
- (void)requestQueryApprovalDataWithDataId:(NSNumber *)dataId type:(NSNumber *)type bean:(NSString *)bean processInstanceId:(NSString *)processInstanceId taskKey:(NSString *)taskKey;

/** 获取chart列表 */
- (void)requestChartList;
/** 获取所有应用 */
- (void)requestAllApplication;
/** 获取应用下的模块 */
- (void)requestModuleWithApplicationId:(NSNumber *)applicationId;
/** 判断模块是否有新建权限 */
- (void)requestHaveAuthWithModuleId:(NSNumber *)moduleId;

/** 获取自定义选择范围人员 */
- (void)requestCustomRangePeopleWithRangePeople:(NSArray *)rangePeople;

/** 判断模块是否有阅读权限 */
- (void)requestHaveReadAuthWithModuleBean:(NSString *)bean withDataId:(NSNumber *)dataId;

/** 快速新增 */
-(void)requestQuickAdd;
/** 生成条形码 */
-(void)requestCreateBarcodeWithBarcodeType:(NSString *)barcodeType barcodeValue:(NSString *)barcodeValue;
/** 条形码获取详情 */
-(void)requestBarcodeDetailWithBarcodeValue:(NSString *)barcodeValue;
/** 条形码图片 */
-(void)requestBarcodePictureWithBean:(NSString *)bean barcodeValue:(NSString *)barcodeValue;
/** 获取某模块数据条件字段列表 */
-(void)requestGetConditionFieldListWithBean:(NSString *)bean;
/** 条件字段value变更触发获取联动字段列表和value */
-(void)requestGetLinkageFieldListWithDict:(NSDictionary *)dict;

/** 获取固定模块 */
-(void)requestGetSystemStableModule;
/** 获取固定模块(有权限) */
-(void)requestGetAuthSystemStableModule;
/** 获取某模块自动匹配模块列表 */
-(void)requestAutoMatchModuleWithBean:(NSString *)bean;
/** 获取自动匹配模块数据列表 */
-(void)requestAutoMatchModuleDataListWithDataId:(NSNumber *)dataId sorceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean pageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum ruleId:(NSNumber *)ruleId;
/** 获取某模块的匹配规则列表 */
-(void)requsetAutoMatchRuleListWithSourceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean;
/** 获取规则下的匹配到的数据列表 */
-(void)requestAutoMatchRuleDataListWithDataId:(NSNumber *)dataId ruleId:(NSNumber *)ruleId bean:(NSString *)bean pageSize:(NSNumber *)pageSize pageNum:(NSNumber *)pageNum;
/** 获取页签列表 */
-(void)requestTabListWithBean:(NSString *)bean dataId:(NSNumber *)dataId;
/** 获取页签下的数据列表 */
-(void)requestTabDataWithTabId:(NSNumber *)tabId dataAuth:(NSNumber *)dataAuth dataId:(NSNumber *)dataId ruleId:(NSNumber *)ruleId moduleId:(NSNumber *)moduleId dataType:(NSNumber *)dataType pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;
/** 获取关联页签下新建获取关联映射字段值 */
-(void)requestReferanceReflectWithSorceBean:(NSString *)sorceBean targetBean:(NSString *)targetBean detailJson:(NSString *)detailJson;

/** 获取web链接列表 */
-(void)requestWebLinkListWithModuleBean:(NSString *)moduleBean source:(NSNumber *)source seasPoolId:(NSNumber *)seasPoolId relevanceModule:(NSString *)relevanceModule relevanceField:(NSString *)relevanceField relevanceValue:(NSString *)relevanceValue;

/** 获取显示模块 */
-(void)requestWorkEnterShowModule;
/** 获取所有模块 */
-(void)requestAllModule;
/** 保存常用模块 */
- (void)requestSaveOftenModules:(NSArray *)modules;

/** 子表选项关联 */
-(void)requestSubformRalationWithDict:(NSDictionary *)dict;

/** 简历解析上传 */
-(void)requestResumeWithBean:(NSString *)bean files:(NSArray *)files;



@end
