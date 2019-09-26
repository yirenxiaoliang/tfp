//
//  TFProjParticipantModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"

@protocol TFProjParticipantModel @end

@interface TFProjParticipantModel : JSONModel

/** 部门名字 */
@property (nonatomic, copy) NSString <Optional>*departmentName;
/** 员工名字 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 员工头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;
/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 是否为创建者 0：不是 1：是 */
@property (nonatomic, strong) NSNumber <Optional>*isCreator;
/** 是否为执行者 0：不是 1：是 */
@property (nonatomic, strong) NSNumber <Optional>*isManager;
/** 任务列表id */
@property (nonatomic, strong) NSNumber <Optional>*taskListId;
/** 任务列表id */
@property (nonatomic, strong) NSNumber <Optional>*isPrincipal;
/** 员工状态 */
@property (nonatomic, strong) NSNumber <Optional>*employeeStatus;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;


+(HQEmployModel *)employModelForProjParticipantModel:(TFProjParticipantModel *)model;

@end
