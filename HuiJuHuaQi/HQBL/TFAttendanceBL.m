//
//  TFAttendanceBL.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAttendanceBL.h"
#import "TFAtdWayListModel.h"
#import "TFAtdClassListModel.h"
#import "TFPCRuleListModel.h"
#import "TFPCSettingDetailMocel.h"
#import "TFAtdClassDetailModel.h"
#import "TFReferenceApprovalModel.h"
#import "TFModuleModel.h"
#import "TFAttendenceFieldModel.h"
#import "TFArrangeClassModel.h"
#import "TFAttendanceStatisticsModel.h"
#import "TFGroupListModel.h"
#import "TFRankPeopleModel.h"
#import "TFCalendarMonthModel.h"

@implementation TFAttendanceBL

#pragma mark ------------考勤方式
/** 添加考勤方式 */
- (void)requestAddAttendanceWayWithModel:(TFAddAtdWayModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceWaySave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceWaySave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 考勤方式列表 */
- (void)requestGetAttendanceWayListWithType:(NSNumber *)type pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (type) {
        
        [dict setObject:type forKey:@"type"];
    }
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceWayFindList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceWayFindList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 修改考勤方式 */
- (void)requestUpdateAttendanceWayWithModel:(TFAddAtdWayModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceWayUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceWayUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 删除考勤方式 */
- (void)requestDelAttendanceWayWithId:(NSNumber *)wayId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (wayId) {
        
        [dict setObject:wayId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceWayDel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceWayDel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 考勤方式详情 */
- (void)requestGetAttendanceWayDetailWithId:(NSNumber *)wayId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (wayId) {
        
        [dict setObject:wayId forKey:@"id"];
    }

    NSString *url = [super urlFromCmd:HQCMD_attendanceWayFindDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceWayFindDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

#pragma mark ------------班次管理
/** 添加班次管理 */
- (void)requestAddAttendanceClassWithModel:(TFAtdClassModel *)model {
    
//    NSDictionary *dict = [model toDictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:TEXT(model.name) forKey:@"name"];
    [dict setObject:TEXT(model.classDesc) forKey:@"classDesc"];
    [dict setObject:TEXT(model.classType) forKey:@"classType"];
    [dict setObject:TEXT(model.time1Start) forKey:@"time1Start"];
    [dict setObject:TEXT(model.time1End) forKey:@"time1End"];
    [dict setObject:TEXT(model.time1StartLimit) forKey:@"time1StartLimit"];
    [dict setObject:TEXT(model.time1EndLimit) forKey:@"time1EndLimit"];
    [dict setObject:TEXT(model.time1EndStatus) forKey:@"time1EndStatus"];
    [dict setObject:TEXT(model.rest1Start) forKey:@"rest1Start"];
    [dict setObject:TEXT(model.rest1End) forKey:@"rest1End"];
    [dict setObject:TEXT(model.time2Start) forKey:@"time2Start"];
    [dict setObject:TEXT(model.time2End) forKey:@"time2End"];
    [dict setObject:TEXT(model.time2StartLimit) forKey:@"time2StartLimit"];
    [dict setObject:TEXT(model.time2EndLimit) forKey:@"time2EndLimit"];
    [dict setObject:TEXT(model.time2EndStatus) forKey:@"time2EndStatus"];
    [dict setObject:TEXT(model.time3Start) forKey:@"time3Start"];
    [dict setObject:TEXT(model.time3End) forKey:@"time3End"];
    [dict setObject:TEXT(model.time3StartLimit) forKey:@"time3StartLimit"];
    [dict setObject:TEXT(model.time3EndLimit) forKey:@"time3EndLimit"];
    [dict setObject:TEXT(model.time3EndStatus) forKey:@"time3EndStatus"];
    [dict setObject:TEXT(model.totalWorkingHours) forKey:@"totalWorkingHours"];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceClassSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceClassSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 班次管理列表 */
- (void)requestGetAttendanceClassFindListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceClassFindList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceClassFindList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 删除班次管理 */
- (void)requestDelAttendanceClassWithId:(NSNumber *)classId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (classId) {
        
        [dict setObject:classId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceClassDel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceClassDel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 修改班次管理 */
- (void)requestUpdateAttendanceClassWithModel:(TFAtdClassModel *)model {
    
//    NSDictionary *dict = [model toDictionary];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (model.id) {
        [dict setObject:model.id forKey:@"id"];
    }
    [dict setObject:TEXT(model.name) forKey:@"name"];
    [dict setObject:TEXT(model.classDesc) forKey:@"classDesc"];
    [dict setObject:TEXT(model.classType) forKey:@"classType"];
    [dict setObject:TEXT(model.time1Start) forKey:@"time1Start"];
    [dict setObject:TEXT(model.time1End) forKey:@"time1End"];
    [dict setObject:TEXT(model.time1StartLimit) forKey:@"time1StartLimit"];
    [dict setObject:TEXT(model.time1EndLimit) forKey:@"time1EndLimit"];
    [dict setObject:TEXT(model.time1EndStatus) forKey:@"time1EndStatus"];
    [dict setObject:TEXT(model.rest1Start) forKey:@"rest1Start"];
    [dict setObject:TEXT(model.rest1End) forKey:@"rest1End"];
    [dict setObject:TEXT(model.time2Start) forKey:@"time2Start"];
    [dict setObject:TEXT(model.time2End) forKey:@"time2End"];
    [dict setObject:TEXT(model.time2StartLimit) forKey:@"time2StartLimit"];
    [dict setObject:TEXT(model.time2EndLimit) forKey:@"time2EndLimit"];
    [dict setObject:TEXT(model.time2EndStatus) forKey:@"time2EndStatus"];
    [dict setObject:TEXT(model.time3Start) forKey:@"time3Start"];
    [dict setObject:TEXT(model.time3End) forKey:@"time3End"];
    [dict setObject:TEXT(model.time3StartLimit) forKey:@"time3StartLimit"];
    [dict setObject:TEXT(model.time3EndLimit) forKey:@"time3EndLimit"];
    [dict setObject:TEXT(model.time3EndStatus) forKey:@"time3EndStatus"];
    [dict setObject:TEXT(model.totalWorkingHours) forKey:@"totalWorkingHours"];
    [dict setObject:TEXT(model.effectiveDate) forKey:@"effectiveDate"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceClassUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceClassUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 班次管理详情 */
- (void)requestGetAttendanceClassFindDetailWithId:(NSNumber *)classId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (classId) {
        
        [dict setObject:classId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceClassFindDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceClassFindDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

#pragma mark ------------考勤规则
/** 添加考勤规则 */
- (void)requestAddAttendanceScheduleWithDict:(NSDictionary *)dict {
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleSave];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceScheduleSave
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 考勤规则列表 */
- (void)requestGetAttendanceScheduleFindListWithPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        
        [dict setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize) {
        
        [dict setObject:pageSize forKey:@"pageSize"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleFindList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceScheduleFindList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 删除考勤规则 */
- (void)requestDelAttendanceScheduleWithId:(NSNumber *)ruleId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (ruleId) {
        
        [dict setObject:ruleId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleDel];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceScheduleDel
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 修改考勤规则 */
- (void)requestUpdateAttendanceScheduleWithDict:(NSDictionary *)dict{
    
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceScheduleUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 考勤规则详情 */
- (void)requestGetAttendanceScheduleDetailWithId:(NSNumber *)ruleId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (ruleId) {
        
        [dict setObject:ruleId forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleFindDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceScheduleFindDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

#pragma mark ------------其他设置
/** 其他设置新增管理员 */
- (void)requestAddAttendanceSettingSaveAdminWithModel:(NSString *)ids {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (ids) {
        [dict setObject:ids forKey:@"adminArr"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveAdmin];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveAdmin
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置修改管理员 */
- (void)requestAttendanceSettingUpdateWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置新增/修改打卡提醒 */
- (void)requestAttendanceSettingSaveRemindWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveRemind];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveRemind
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置新增/修改榜单设置 */
- (void)requestAttendanceSettingSaveCountWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveCount];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveCount
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置新增/修改晚走晚到 */
- (void)requestAttendanceSettingSaveLateWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveLate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveLate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置新增/修改人性化班次 */
- (void)requestAttendanceSettingSaveHommizationWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveHommization];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveHommization
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置新增/修改旷工规则 */
- (void)requestAttendanceSettingSaveAbsenteeismWithModel:(TFPCOtherSettingModel *)model {
    
    NSDictionary *dict = [model toDictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingSaveAbsenteeism];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceSettingSaveAbsenteeism
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 其他设置根据ID查询详情 */
- (void)requestGetAttendanceSettingFindDetail {
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceSettingFindDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceSettingFindDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 晚走晚到 */
-(void)requestSaveLateWorkWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceLateWork];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceLateWork
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark ------------排班详情
/** 排班详情查询 */
- (void)requestGetAttendanceManagementFindAppDetailWithMonth:(NSNumber *)month employeeId:(NSNumber *)employeeId {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (month) {
        [dict setObject:month forKey:@"month"];
    }
    if (employeeId) {
        [dict setObject:employeeId forKey:@"employeeId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceManagementFindAppDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceManagementFindAppDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 获取考勤组列表 */
- (void)requestGetAttendanceScheduleFindScheduleList {
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceScheduleFindScheduleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceScheduleFindScheduleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 排班周期详情 */
- (void)requestGetAttendanceCycleFindDetailWithScheduleId:(NSNumber *)scheduleId {
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceCycleFindDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceCycleFindDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

#pragma mark - 打卡
/** 获取当日考勤信息 */
-(void)requestGetTodayAttendanceInfo{
    
    NSString *url = [super urlFromCmd:HQCMD_getTodayAttendanceInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getTodayAttendanceInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 获取当日打卡记录 */
-(void)requestGetTodayAttendanceRecord{
    
    NSString *url = [super urlFromCmd:HQCMD_getTodayAttendanceRecord];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getTodayAttendanceRecord
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 打卡 */
-(void)requestPunchAttendanceWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_punchAttendance];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_punchAttendance
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


#pragma mark ------------考勤统计
/** 日统计 */
-(void)requestDayStatisticsDataWithAttendanceDay:(NSNumber *)attendanceDay{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceDay) {
        [dict setObject:attendanceDay forKey:@"attendanceDate"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceDayStatistics];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceDayStatistics
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 月统计 */
-(void)requestMonthStatisticsDataWithAttendanceMonth:(NSNumber *)attendanceMonth{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceMonth) {
        [dict setObject:attendanceMonth forKey:@"attendanceMonth"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceMonthStatistics];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceMonthStatistics
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 我的月统计 */
-(void)requestMyMonthStatisticsDataWithAttendanceMonth:(NSNumber *)attendanceMonth{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (attendanceMonth) {
        [dict setObject:attendanceMonth forKey:@"attendanceMonth"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_myMonthStatistics];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_myMonthStatistics
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 打卡月历 */
-(void)requestAttendanceDataWithAttendanceMonth:(NSNumber *)attendanceMonth employeeId:(NSNumber *)employeeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceMonth) {
        [dict setObject:attendanceMonth forKey:@"attendanceMonth"];
    }
    if (employeeId) {
        [dict setObject:employeeId forKey:@"employeeId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceEmployeeMonthStatistics];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceEmployeeMonthStatistics
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 早到榜 */
-(void)requestAttendanceEarlyDataWithAttendanceDate:(NSNumber *)attendanceDate groupId:(NSNumber *)groupId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceDate) {
        [dict setObject:attendanceDate forKey:@"attendanceDate"];
    }
    if (groupId) {
        [dict setObject:groupId forKey:@"groupId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceEarlyRank];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceEarlyRank
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 勤勉榜 */
-(void)requestAttendanceHardworkingDataWithAttendanceMonth:(NSNumber *)attendanceMonth groupId:(NSNumber *)groupId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceMonth) {
        [dict setObject:attendanceMonth forKey:@"attendanceMonth"];
    }
    if (groupId) {
        [dict setObject:groupId forKey:@"groupId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceHardworkingRank];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceHardworkingRank
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 迟到榜 */
-(void)requestAttendanceLateDataWithAttendanceMonth:(NSNumber *)attendanceMonth groupId:(NSNumber *)groupId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceMonth) {
        [dict setObject:attendanceMonth forKey:@"attendanceMonth"];
    }
    if (groupId) {
        [dict setObject:groupId forKey:@"groupId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceLateRank];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceLateRank
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 榜单考勤组 */
-(void)requestAttendanceGroupList{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceGroupList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceGroupList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 打卡人员列表 */
-(void)requestAttendancePeoplesWithAttendanceDate:(NSNumber *)attendanceDate{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceDate) {
        [dict setObject:attendanceDate forKey:@"attendanceDate"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendancePunchPeoples];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendancePunchPeoples
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 打卡状态人员列表
 *@param attendanceDate 考勤日期
 *@param attendanceType 方式 0：日统计，1：月统计
 *@param attendanceStatus 状态 1：迟到，2：早退，3：外勤打卡，4：缺卡，5：旷工，6：外勤打卡
 *@param employeeId 员工编号
 */
-(void)requestAttendancePeoplesWithAttendanceDate:(NSNumber *)attendanceDate attendanceType:(NSNumber *)attendanceType attendanceStatus:(NSNumber *)attendanceStatus employeeId:(NSNumber *)employeeId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (attendanceDate) {
        [dict setObject:attendanceDate forKey:@"attendanceDate"];
    }
    if (attendanceType) {
        [dict setObject:attendanceType forKey:@"attendanceType"];
    }
    if (attendanceStatus) {
        [dict setObject:attendanceStatus forKey:@"attendanceStatus"];
    }
    if (employeeId) {
        [dict setObject:employeeId forKey:@"employeeId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_attendancePunchStatusPeoples];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendancePunchStatusPeoples
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


#pragma mark ------------关联审批单
-(void)requestReferenceApprovalList{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceReferenceApprovalList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceReferenceApprovalList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 删除审批单 */
-(void)requestReferenceApprovalDeleteWithReferenceId:(NSNumber *)referenceId{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (referenceId) {
        [dict setObject:referenceId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_attendanceReferenceApprovalDelete];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceReferenceApprovalDelete
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批单详情 */
-(void)requestReferenceApprovalDetailWithReferenceId:(NSNumber *)referenceId{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (referenceId) {
        [dict setObject:referenceId forKey:@"id"];
    }
    NSString *url = [super urlFromCmd:HQCMD_attendanceReferenceApprovalDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceReferenceApprovalDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批新增 */
-(void)requestReferenceApprovalCreateWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceReferenceApprovalCreate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceReferenceApprovalCreate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批编辑 */
-(void)requestReferenceApprovalUpdateWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceReferenceApprovalUpdate];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceReferenceApprovalUpdate
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批模块 */
-(void)requestApprovalList{
    
    NSString *url = [super urlFromCmd:HQCMD_attendanceApprovalModuleList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_attendanceApprovalModuleList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}
/** 审批模块字段 */
-(void)requestApprovalFieldWithBean:(NSString *)bean{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    [dict setObject:@1 forKey:@"systemField"];
    NSString *url = [super urlFromCmd:HQCMD_attendanceApprovalModuleField];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_attendanceApprovalModuleField
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
                
            case HQCMD_attendanceWaySave:// 添加考勤方式
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceWayFindList: // 考勤方式列表
            {
                
                NSDictionary *dict = data[kData];
                
                NSError *error = nil;
                TFAtdWayListModel *model = [[TFAtdWayListModel alloc] initWithDictionary:dict error:&error];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceWayUpdate:// 修改考勤方式
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceWayDel:// 删除考勤方式
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceWayFindDetail:// 考勤方式详情
            {
                TFAddAtdWayModel *model = [[TFAddAtdWayModel alloc] initWithDictionary:data[kData] error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceClassSave:// 添加班次管理
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceClassFindList: //班次管理列表
            {
                
                NSDictionary *dict = data[kData];
                
                TFAtdClassListModel *model = [[TFAtdClassListModel alloc] initWithDictionary:dict error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceClassDel:// 删除班次管理
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceClassUpdate:// 修改班次管理
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceClassFindDetail:// 班次管理详情
            {
                NSDictionary *dict = data[kData];
                TFAtdClassModel *model = [[TFAtdClassModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceScheduleSave:// 添加考勤规则
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceScheduleFindList:// 考勤规则列表
            {
                
                NSDictionary *dic = data[kData];
                NSArray *arr = [dic valueForKey:@"dataList"];
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                    TFPCRuleListModel *model = [[TFPCRuleListModel alloc] initWithDictionary:dict error:nil];
                    model.dict = dict;
                    [array addObject:model];
                    
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:array];
            }
                break;
                
            case HQCMD_attendanceScheduleDel:// 删除考勤规则
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceScheduleUpdate:// 修改考勤规则
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceScheduleFindDetail:// 考勤规则详情
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceSettingSaveAdmin:// 其他设置修改管理员
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceSettingUpdate:// 其他设置修改管理员
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceSettingSaveRemind://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceSettingSaveCount://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceSettingSaveLate://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_attendanceSettingSaveHommization://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_attendanceSettingSaveAbsenteeism://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_attendanceSettingFindDetail://
            {
                NSDictionary *dic = data[kData];
                TFPCSettingDetailMocel *model = [[TFPCSettingDetailMocel alloc] initWithDictionary:dic error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceLateWork:// 晚走晚到
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_attendanceManagementFindAppDetail://
            {
                NSDictionary *dic = data[kData];
                
                TFArrangeClassModel *model = [[TFArrangeClassModel alloc] initWithDictionary:dic error:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
                
            case HQCMD_attendanceScheduleFindScheduleList://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
                
            case HQCMD_attendanceCycleFindDetail://
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:nil];
            }
                break;
            case HQCMD_getTodayAttendanceInfo:// 获取当日考勤信息
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getTodayAttendanceRecord:// 获取当日打卡记录
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_punchAttendance:// 打卡
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
                
            case HQCMD_attendanceDayStatistics:// 日统计
            {
                NSDictionary *dict = data[kData];
                NSError *error;
                TFAttendanceStatisticsModel *model = [[TFAttendanceStatisticsModel alloc] initWithDictionary:dict error:&error];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_attendanceMonthStatistics:// 月统计
            {
                NSDictionary *dict = data[kData];
                TFAttendanceStatisticsModel *model = [[TFAttendanceStatisticsModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_myMonthStatistics:// 我的月统计
            {
                NSDictionary *dict = data[kData];
                TFAttendanceStatisticsModel *model = [[TFAttendanceStatisticsModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_attendanceEmployeeMonthStatistics:// 打卡月历
            {
                NSDictionary *dict = data[kData];
                TFCalendarMonthModel *model = [[TFCalendarMonthModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_attendanceEarlyRank:// 早到榜
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFRankPeopleModel *em = [[TFRankPeopleModel alloc] initWithDictionary:dict error:nil];
                    if (em) {
                        [models addObject:em];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_attendanceHardworkingRank:// 勤勉榜
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFRankPeopleModel *em = [[TFRankPeopleModel alloc] initWithDictionary:dict error:nil];
                    if (em) {
                        [models addObject:em];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_attendanceLateRank:// 迟到榜
            {
                NSDictionary *dict = data[kData];
                NSArray *arr = [dict valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFRankPeopleModel *em = [[TFRankPeopleModel alloc] initWithDictionary:dict error:nil];
                    if (em) {
                        [models addObject:em];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_attendanceGroupList:// 考勤组列表
            {
                NSDictionary *dict = data[kData];
                TFGroupListModel *model = [[TFGroupListModel alloc] initWithDictionary:dict error:nil];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:model];
            }
                break;
            case HQCMD_attendancePunchPeoples:// 打卡人员列表
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_attendancePunchStatusPeoples:// 打卡状态人员列表
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_attendanceReferenceApprovalList:// 关联审批列表
            {
                NSDictionary *dict1 = data[kData];
                NSArray *arr = [dict1 valueForKey:@"dataList"];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFReferenceApprovalModel *model = [[TFReferenceApprovalModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_attendanceReferenceApprovalCreate:// 关联审批创建
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_attendanceReferenceApprovalUpdate:// 关联审批修改
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_attendanceReferenceApprovalDetail:// 关联审批详情
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_attendanceReferenceApprovalDelete:// 关联审批删除
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_attendanceApprovalModuleList:// 审批列表
            {
                NSDictionary *dd = data[kData];
                NSArray *arr = [dd valueForKey:@"dataList"];
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
            case HQCMD_attendanceApprovalModuleField:// 审批字段
            {
                NSDictionary *arr = data[kData];
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFAttendenceFieldModel *model = [[TFAttendenceFieldModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
                
            default:
                break;
        }
        [super succeedCallbackWithResponse:resp];
    }
}



@end
