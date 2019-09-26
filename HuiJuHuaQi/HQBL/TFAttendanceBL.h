//
//  TFAttendanceBL.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "TFAddAtdWayModel.h"
#import "TFAtdClassModel.h"
#import "TFPCRuleModel.h"
#import "TFPCOtherSettingModel.h"

@interface TFAttendanceBL : HQBaseBL

#pragma mark ------------考勤方式
/** 添加考勤方式 */
- (void)requestAddAttendanceWayWithModel:(TFAddAtdWayModel *)model;

/** 考勤方式列表 */
- (void)requestGetAttendanceWayListWithType:(NSNumber *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 修改考勤方式 */
- (void)requestUpdateAttendanceWayWithModel:(TFAddAtdWayModel *)model;

/** 删除考勤方式 */
- (void)requestDelAttendanceWayWithId:(NSNumber *)wayId;

/** 考勤方式详情 */
- (void)requestGetAttendanceWayDetailWithId:(NSNumber *)wayId;

#pragma mark ------------班次管理
/** 添加班次管理 */
- (void)requestAddAttendanceClassWithModel:(TFAtdClassModel *)model;

/** 班次管理列表 */
- (void)requestGetAttendanceClassFindListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 删除班次管理 */
- (void)requestDelAttendanceClassWithId:(NSNumber *)classId;

/** 修改班次管理 */
- (void)requestUpdateAttendanceClassWithModel:(TFAtdClassModel *)model;

/** 班次管理详情 */
- (void)requestGetAttendanceClassFindDetailWithId:(NSNumber *)classId;

#pragma mark ------------考勤规则
/** 添加考勤规则 */
- (void)requestAddAttendanceScheduleWithDict:(NSDictionary *)dict;

/** 考勤规则列表 */
- (void)requestGetAttendanceScheduleFindListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize;

/** 删除考勤规则 */
- (void)requestDelAttendanceScheduleWithId:(NSNumber *)ruleId;

/** 修改考勤规则 */
- (void)requestUpdateAttendanceScheduleWithDict:(NSDictionary *)dict;

/** 考勤规则详情 */
- (void)requestGetAttendanceScheduleDetailWithId:(NSNumber *)ruleId;

#pragma mark ------------其他设置
/** 其他设置新增管理员 */
- (void)requestAddAttendanceSettingSaveAdminWithModel:(NSString *)ids;
/** 其他设置修改管理员 */
- (void)requestAttendanceSettingUpdateWithModel:(TFPCOtherSettingModel *)model;
/** 其他设置新增/修改打卡提醒 */
- (void)requestAttendanceSettingSaveRemindWithModel:(TFPCOtherSettingModel *)model;
/** 其他设置新增/修改榜单设置 */
- (void)requestAttendanceSettingSaveCountWithModel:(TFPCOtherSettingModel *)model;
/** 其他设置新增/修改人性化班次 */
- (void)requestAttendanceSettingSaveHommizationWithModel:(TFPCOtherSettingModel *)model;
/** 其他设置新增/修改旷工规则 */
- (void)requestAttendanceSettingSaveAbsenteeismWithModel:(TFPCOtherSettingModel *)model;
/** 其他设置查询详情 */
- (void)requestGetAttendanceSettingFindDetail;
/** 晚走晚到 */
-(void)requestSaveLateWorkWithDict:(NSDictionary *)dict;

#pragma mark ------------排班详情
/** 排班详情查询 */
- (void)requestGetAttendanceManagementFindAppDetailWithMonth:(NSNumber *)month employeeId:(NSNumber *)employeeId;
/** 获取考勤组列表 */
- (void)requestGetAttendanceScheduleFindScheduleList;
/** 排班周期详情 */
- (void)requestGetAttendanceCycleFindDetailWithScheduleId:(NSNumber *)scheduleId;

#pragma mark -----------打卡
/** 获取当日考勤信息 */
-(void)requestGetTodayAttendanceInfo;
/** 获取当日打卡记录 */
-(void)requestGetTodayAttendanceRecord;
/** 打卡 */
-(void)requestPunchAttendanceWithDict:(NSDictionary *)dict;

#pragma mark ------------考勤统计
/** 日统计 */
-(void)requestDayStatisticsDataWithAttendanceDay:(NSNumber *)attendanceDay;
/** 月统计 */
-(void)requestMonthStatisticsDataWithAttendanceMonth:(NSNumber *)attendanceMonth;
/** 我的月统计 */
-(void)requestMyMonthStatisticsDataWithAttendanceMonth:(NSNumber *)attendanceMonth;
/** 打卡月历 */
-(void)requestAttendanceDataWithAttendanceMonth:(NSNumber *)attendanceMonth employeeId:(NSNumber *)employeeId;
/** 早到榜 */
-(void)requestAttendanceEarlyDataWithAttendanceDate:(NSNumber *)attendanceDate groupId:(NSNumber *)groupId;
/** 勤勉榜 */
-(void)requestAttendanceHardworkingDataWithAttendanceMonth:(NSNumber *)attendanceMonth groupId:(NSNumber *)groupId;
/** 迟到榜 */
-(void)requestAttendanceLateDataWithAttendanceMonth:(NSNumber *)attendanceMonth groupId:(NSNumber *)groupId;
/** 榜单考勤组 */
-(void)requestAttendanceGroupList;
/** 打卡人员列表 */
-(void)requestAttendancePeoplesWithAttendanceDate:(NSNumber *)attendanceDate;
/** 打卡状态人员列表
 *@param attendanceDate 考勤日期
 *@param attendanceType 方式 0：日统计，1：月统计
 *@param attendanceStatus 状态 1：迟到，2：早退，3：外勤打卡，4：缺卡，5：旷工，6：外勤打卡
 *@param employeeId 员工编号
 */
-(void)requestAttendancePeoplesWithAttendanceDate:(NSNumber *)attendanceDate attendanceType:(NSNumber *)attendanceType attendanceStatus:(NSNumber *)attendanceStatus employeeId:(NSNumber *)employeeId;

#pragma mark ------------关联审批单
/** 审批单列表 */
-(void)requestReferenceApprovalList;
/** 删除审批单 */
-(void)requestReferenceApprovalDeleteWithReferenceId:(NSNumber *)referenceId;
/** 审批单详情 */
-(void)requestReferenceApprovalDetailWithReferenceId:(NSNumber *)referenceId;
/** 审批新增 */
-(void)requestReferenceApprovalCreateWithDict:(NSDictionary *)dict;
/** 审批编辑 */
-(void)requestReferenceApprovalUpdateWithDict:(NSDictionary *)dict;
/** 审批模块 */
-(void)requestApprovalList;
/** 审批模块字段 */
-(void)requestApprovalFieldWithBean:(NSString *)bean;


@end
