//
//  HQCoreDataManager.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "TFUserLoginCModel+CoreDataClass.h"
#import "TFUserLoginCModel+CoreDataProperties.h"
#import "TFCompanyCModel+CoreDataClass.h"
#import "TFCompanyCModel+CoreDataProperties.h"
#import "TFEmployeeCModel+CoreDataClass.h"
#import "TFEmployeeCModel+CoreDataProperties.h"
#import "TFDepartmentCModel+CoreDataClass.h"
#import "TFDepartmentCModel+CoreDataProperties.h"


#define CDM [HQCoreDataManager defaultCoreDataManager]


@interface HQCoreDataManager : NSObject

@property (nonatomic, strong) AppDelegate *appDelegate;

//单例
+ (instancetype)defaultCoreDataManager;

////保存登录数据
//- (void)saveUserLoginWithDic:(NSDictionary *)loginInfo;
//
////删除登录数据
//- (void)deleteUserData;
//
////查找登录数据
//- (NSArray *)fetchUserData;
//
//
//- (NSMutableArray *)fetchDocument:(NSNumber *)employId;
//
////一般查找
//- (NSArray *)fetchDataWithClass:(NSString *)className
//                      predicate:(NSPredicate *)pr
//                 sortDescriptor:(NSSortDescriptor *)sort;
//
//
////一般删除
//- (void)deleteDataWithClass:(NSString *)className
//                  predicate:(NSPredicate *)pr
//             sortDescriptor:(NSSortDescriptor *)sort;
//
//
////修改用户手机号
//- (void)saveUserInfoWithTelephone:(NSString *)telephone;
//
////收到修改员工数据推送
//- (void)saveEmployInfoWith:(NSDictionary *)employDic;
//
////收到修改所有员工数据推送
//- (void)saveAllEmployInfoWith:(NSArray *)employArr;
//
////收到修改部门数据推送
//- (void)saveDepartmentInfoWithDepartments:(NSArray *)departments;
//
////收到修改权限数据推送
//- (void)changeAuthorityWithAuthoritys:(NSArray *)authoritys;
//
//
////保存默认公司
//- (void)saveUserCacheWithTelphone:(NSString *)telphone
//                   defaultCompany:(NSNumber *)defaultCompany;
//
//
//
////保存企业圈背景图
//- (void)changeCircleBgImage:(NSString *)urlForBgStr;
//
//
//
////保存班次信息
//- (void)saveDispatchListWithDic:(NSDictionary *)dic
//                      predicate:(NSPredicate *)pr
//                 sortDescriptor:(NSSortDescriptor *)sort;
//
//
//// 保存二维码信息（邮箱、公司网址、公司地址、备注）
//- (void)saveBarcodeWith:(NSDictionary *)dic ;
//
//
//
//// 保存聊天信息
//- (void)saveChatSetTopWithWeChatId:(NSString *)weChatId
//                     conversations:(NSArray *)conversations;
//
//
//// 更改聊天信息
//- (void)changeChatSetTopWithWeChatId:(NSString *)weChatId
//                      conversationId:(NSString *)conversationId
//                          setTopSate:(BOOL)setTopSate;
//
////查询聊天信息
//- (NSArray *)fetchChatSetTopWithWeChatId:(NSString *)weChatId;
//
//
////查询星标
//- (NSArray *)fetchStar:(NSString *)isStar EmployId:(NSNumber *)employId;
//
////查询名称
//- (NSArray *)fetchName:(NSString *)isName;
//
////查询类型
//- (NSArray *)fetchType:(NSString *)isType EmployId:(NSNumber *)employId;
//
//
///** 保存电话、email等 */
//- (HQCustomerStringCModel *)saveCustomerStringWithDic:(NSDictionary *)dic;
//
//
///** 保存客户信息 */
//- (HQCustomerCModel *)saveCustomerWithDic:(NSDictionary *)dic;
///** 删除客户信息 */
//- (void)removeContactWithEmployeeID:(NSNumber *)employeeID customerID:(NSNumber *)customerID;
///** 查询客户 */
//- (NSMutableArray *)queryCustomerWithEmployeeID:(NSNumber *)emplyeeID;
//
//
///** 保存权限信息 */
//- (HQCustomerStringCModel *)saveAuthrityWithString:(NSString *)string;
//
//
///** 保存用户注册的信息 */
//- (void)saveUserRegisterWithDic:(NSDictionary *)loginInfo;


/*************************************新存储****************************************/


/** 保存文件信息 */
- (void)saveFileWithDic:(NSDictionary *)dic;

/** 找到所有下载文件 */
- (NSArray *)fetchFiles;

/** 删除某条文件 */
- (void)removeFileWithFileId:(NSString *)fileId;

/** 保存当前登录员工信息 */
- (void)saveCurrentLoginEmployeeWithDic:(NSDictionary *)loginInfo;

/** 查找当前登录员工信息 */
- (NSArray *)fetchCurrentEmployeeData;

/** 删除当前登录员工信息 */
- (void)deleteCurrentEmployeeData;

/** 退出登录修改登录状态 */
- (void)logoutUpdataIsLogin;

/** 更新公司员工列表 */
- (void)updataEmployeesWithEmployees:(NSArray *)employees;

/** 某一个员工 */
- (TFEmployeeCModel *)fetchEmployeeDataWithEmployeeId:(NSNumber *)employeeId signId:(NSNumber *)signId;

/** 修改员工的电话 */
- (void)saveEmployeePhone:(NSString *)phone;

/** 修改员工的心情和签名 */
- (void)saveEmployeeMood:(NSString *)mood sign:(NSString *)sign;


@end
