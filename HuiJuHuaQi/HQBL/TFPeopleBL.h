//
//  TFPeopleBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import "HQEmployModel.h"
#import "TFEmployModel.h"
#import "HQCompanyModel.h"

@interface TFPeopleBL : HQBaseBL


/** ----------新获取员工列表--------- */
/** 获取所有员工列表 */
-(void)requestEmployeeListWithDismiss:(NSNumber *)dismiss;
/** 获取组织架构树 */
-(void)requestCompanyFrameworkWithCompanyId:(NSString *)companyId dismiss:(NSNumber *)dismiss;

/** 编辑员工 */
-(void)requestUpdateEmployeeWithEmployee:(TFEmployModel *)employee;

/** 修改密码 */
-(void)requestModPassWordWithPassWord:(NSString *)passWord newPassWord:(NSString *)newPassWord;

/** 员工详情 */
-(void)requestEmployeeDetailWithEmployeeId:(NSNumber *)employeeId;
/** 获取角色列表 */
-(void)requsetGetRoleGroupList;

/** 组织架构模糊查找 */
-(void)requsetFindByUserNameWithDepartmentId:(NSNumber *)departmentId employeeName:(NSString *)employeeName dismiss:(NSNumber *)dismiss;

/** 动态参数 */
-(void)requsetGetSharePersonalFieldsWithBean:(NSString *)bean type:(NSInteger)type;

@end
