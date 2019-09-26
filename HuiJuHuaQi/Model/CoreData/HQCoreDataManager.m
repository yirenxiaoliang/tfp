//
//  HQCoreDataManager.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQCoreDataManager.h"
#import "HQUserManager.h"



/**********新存储*************/

#import "TFFileCModel+CoreDataClass.h"
#import "TFFileCModel+CoreDataProperties.h"

#import "TFCompanyCModel+CoreDataClass.h"
#import "TFCompanyCModel+CoreDataProperties.h"

#import "TFEmployeeCModel+CoreDataClass.h"
#import "TFEmployeeCModel+CoreDataProperties.h"

#import "TFUserLoginCModel+CoreDataClass.h"
#import "TFUserLoginCModel+CoreDataProperties.h"

@interface HQCoreDataManager ()



@end

static HQCoreDataManager *manager;

@implementation HQCoreDataManager



//单例
+ (instancetype)defaultCoreDataManager
{
    
    @synchronized(self) {
        if (!manager){
            manager = [[HQCoreDataManager alloc] init];
            manager.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        }
    }
    return manager;
}



//一般查找
- (NSArray *)fetchDataWithClass:(NSString *)className
                      predicate:(NSPredicate *)pr
                 sortDescriptor:(NSSortDescriptor *)sort;
{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:className
                                                         inManagedObjectContext:self.appDelegate.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:pr];
    if (sort) {
        [request setSortDescriptors:@[sort]];
    }
    
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    
    return arr;
}



//一般删除
- (void)deleteDataWithClass:(NSString *)className
                  predicate:(NSPredicate *)pr
             sortDescriptor:(NSSortDescriptor *)sort
{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchDataWithClass:className predicate:pr sortDescriptor:sort]];
    
    if (array.count > 0){
        
        for (id model in array) {
            
            [self.appDelegate.managedObjectContext deleteObject:model];
        }
    }
}

#pragma mark - 保存注册用户信息
//- (void)saveUserRegisterWithDic:(NSDictionary *)loginInfo
//{
//    
//    if (loginInfo == nil) {
//        return;
//    }
//    
//    if (![loginInfo isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    
//    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchUserData]];
//    
//    if (array.count > 0){
//        HQLog(@"已有重复数据");
//        [self deleteUserData];
//    }
//    
//    
//    HQUserLoginCModel *userLogin = [NSEntityDescription
//                                    insertNewObjectForEntityForName:@"HQUserLoginCModel"
//                                    inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    // token
//    userLogin.token = [NSString stringWithFormat:@"%@",[[loginInfo objectForKey:@"token"] nullProcess]];
//    // 用户信息
//    userLogin.user = [self saveUserWithDict:[[loginInfo objectForKey:@"user"] nullProcess]];
//    // 员工信息
//    userLogin.employee = [self saveEmployWithDic:[[loginInfo objectForKey:@"employee"] nullProcess]];
//    // 公司信息
//    userLogin.company = [self saveCompanyWithDict:[[loginInfo objectForKey:@"company"] nullProcess]];
//    
//    [self.appDelegate saveContext];
//}


#pragma mark - 保存登录信息
//保存
//- (void)saveUserLoginWithDic:(NSDictionary *)loginInfo
//{
//    
//    if (loginInfo == nil) {
//        return;
//    }
//    
//    if (![loginInfo isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    
//    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchUserData]];
//
//    if (array.count > 0){
//        HQLog(@"已有重复数据");
//        [self deleteUserData];
//    }
//    
//
//    HQUserLoginCModel *userLogin = [NSEntityDescription
//                                    insertNewObjectForEntityForName:@"HQUserLoginCModel"
//                                    inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    
//    userLogin.token = [NSString stringWithFormat:@"%@",[[loginInfo objectForKey:@"token"] nullProcess]];
//    
//    userLogin.isUsedClient = [[loginInfo objectForKey:@"isUsedClient"] nullProcess];
//    
//    // 用户信息
//    userLogin.user = [self saveUserWithDict:[[loginInfo objectForKey:@"user"] nullProcess]];
//
//    // 公司信息
//    userLogin.company = [self saveCompanyWithDict:[[loginInfo objectForKey:@"company"] nullProcess]];
//    
//    
//    
//    // 员工信息
//    userLogin.employee = [self saveEmployWithDic:[[loginInfo objectForKey:@"employee"] nullProcess]];
//    
//    // 公司列表信息
//    NSArray *companyArr = [[loginInfo objectForKey:@"companys"] nullProcess];
//    
//    for (NSDictionary *dic in companyArr) {
//        
//        
//        if (dic && ![dic isKindOfClass:[NSNull class]]) {
//            // "$ref" = "$.company";
//            if ([dic.allKeys containsObject:@"$ref"]) {
//                
//                NSDictionary *dict = [[loginInfo objectForKey:@"company"] nullProcess];
//                
//                [userLogin addCompanysObject:[self saveCompanyWithDict:dict]];
//                
//            }else{
//                [userLogin addCompanysObject:[self saveCompanyWithDict:dic]];
//            }
//        }
//        
//    }
//    
//    [self.appDelegate saveContext];
//}

/** 保存用户 */
//- (HQUserCModel *)saveUserWithDict:(NSDictionary *)dict{
//    
//    if (dict == nil) {
//        return nil;
//    }
//    
//    if (![dict isKindOfClass:[NSDictionary class]]) {
//        return nil;
//    }
//    
//    
//    HQUserCModel *user = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"HQUserCModel"
//                              inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    user.clientType      = [[dict objectForKey:@"clientType"] nullProcess];
//    user.createDate      = [[dict objectForKey:@"createDate"] nullProcess];
//    user.disabled      = [[dict objectForKey:@"disabled"] nullProcess];
//    user.id      = [[dict objectForKey:@"id"] nullProcess];
//    user.latelyClientId      = [[dict objectForKey:@"latelyClientId"] nullProcess];
//    user.latelyCompanyId      = [[dict objectForKey:@"latelyCompanyId"] nullProcess];
//    user.nickName      = [[dict objectForKey:@"nickName"] nullProcess];
//    user.passWord      = [[dict objectForKey:@"passWord"] nullProcess];
//    user.photograph      = [[dict objectForKey:@"photograph"] nullProcess];
//    user.telephone      = [[dict objectForKey:@"telephone"] nullProcess];
//    user.token      = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"token"] nullProcess]];
//    user.tokenValidTime      = [[dict objectForKey:@"tokenValidTime"] nullProcess];
//    user.userCode      = [[dict objectForKey:@"userCode"] nullProcess];
//    
//    user.userName      = [[dict objectForKey:@"userName"] nullProcess];
//    user.userType      = [[dict objectForKey:@"userType"] nullProcess];
//    user.photograph      = [[dict objectForKey:@"photograph"] nullProcess];
//    
//    return user;
//}

/** 保存公司 */
//- (HQCompanyCModel *)saveCompanyWithDict:(NSDictionary *)dict{
//    
//    if (dict == nil) {
//        return nil;
//    }
//    
//    if (![dict isKindOfClass:[NSDictionary class]]) {
//        return nil;
//    }
//    
//    
//    HQCompanyCModel *company = [NSEntityDescription
//                          insertNewObjectForEntityForName:@"HQCompanyCModel"
//                          inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    company.attachmentUrl      = [[dict objectForKey:@"attachmentUrl"] nullProcess];
//    company.companyAddress      = [[dict objectForKey:@"companyAddress"] nullProcess];
//    company.createDate      = [[dict objectForKey:@"createDate"] nullProcess];
//    company.companyName      = [[dict objectForKey:@"companyName"] nullProcess];
//    company.cumulateDays      = [[dict objectForKey:@"cumulateDays"] nullProcess];
//    company.defaultChatGroup      = [[dict objectForKey:@"defaultChatGroup"] nullProcess];
//    company.disabled      = [[dict objectForKey:@"disabled"] nullProcess];
//    company.id      = [[dict objectForKey:@"id"] nullProcess];
//    company.industry      = [[dict objectForKey:@"industry"] nullProcess];
//    company.isMember      = [[dict objectForKey:@"isMember"] nullProcess];
//    company.lealPersonId      = [[dict objectForKey:@"lealPersonId"] nullProcess];
//    company.mark      = [[dict objectForKey:@"mark"] nullProcess];
//    company.region      = [[dict objectForKey:@"region"] nullProcess];
//    company.shortName      = [[dict objectForKey:@"shortName"] nullProcess];
//    company.telephone      = [[dict objectForKey:@"telephone"] nullProcess];
//    company.isDefault      = [[dict objectForKey:@"isDefault"] nullProcess];
//    company.photograph      = [[dict objectForKey:@"photograph"] nullProcess];
//    
//    return company;
//}

/** 保存职员信息 */
//- (HQEmployCModel *)saveEmployWithDic:(NSDictionary *)employDic
//{
//    if (employDic == nil) {
//        return nil;
//    }
//    
//    if (![employDic isKindOfClass:[NSDictionary class]]) {
//        return nil;
//    }
//    
//    
//    HQEmployCModel *employ = [NSEntityDescription
//                              insertNewObjectForEntityForName:@"HQEmployCModel"
//                              inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    
//    employ.companyId      = [[employDic objectForKey:@"companyId"] nullProcess];
//    employ.createDate     = [[employDic objectForKey:@"createDate"] nullProcess];
//    employ.departmentId    = [[employDic objectForKey:@"departmentId"] nullProcess];
//    employ.disabled = [[employDic objectForKey:@"disabled"] nullProcess];
//    employ.emchatId = [[employDic objectForKey:@"emchatId"] nullProcess];
//    employ.employeeName = [[employDic objectForKey:@"employeeName"] nullProcess];
//    employ.employeeNumber     = [[employDic objectForKey:@"employeeNumber"] nullProcess];
//    employ.endStatusTime           = [[employDic objectForKey:@"endStatusTime"] nullProcess];
//    employ.entryDate   = [[employDic objectForKey:@"entryDate"] nullProcess];
//    employ.gender = [[employDic objectForKey:@"gender"] nullProcess];
//    employ.id     = [[employDic objectForKey:@"id"] nullProcess];
//    employ.isActive         = [[employDic objectForKey:@"isActive"] nullProcess];
//    employ.leaveTime    = [[employDic objectForKey:@"leaveTime"] nullProcess];
//    employ.microblogBackground          = [[employDic objectForKey:@"microblogBackground"] nullProcess];
//    employ.operateDate     = [[employDic objectForKey:@"operateDate"] nullProcess];
//    employ.photograph       = [[employDic objectForKey:@"photograph"] nullProcess];
//    employ.position     = [[employDic objectForKey:@"position"] nullProcess];
//    employ.telephone     = [[employDic objectForKey:@"telephone"] nullProcess];
//    employ.userId        = [[employDic objectForKey:@"userId"] nullProcess];
//    employ.workStatus     = [[employDic objectForKey:@"workStatus"] nullProcess];
//    employ.selectState        = [[employDic objectForKey:@"selectState"] nullProcess];
//    employ.disSelectState     = [[employDic objectForKey:@"disSelectState"] nullProcess];
//    employ.levelNum        = [[employDic objectForKey:@"levelNum"] nullProcess];
//    employ.verifyStatus        = [[employDic objectForKey:@"verifyStatus"] nullProcess];
//    employ.imUsername        = [[employDic objectForKey:@"imUsername"] nullProcess];
//    employ.imRegistrationId        = [[employDic objectForKey:@"imRegistrationId"] nullProcess];
//    employ.imPassword        = [[employDic objectForKey:@"imPassword"] nullProcess];
//
//
//    return employ;
//}


//部门信息
//- (HQDepartMentCModel *)saveDepartMentWithDic:(NSDictionary *)dic
//{
//    
//    HQDepartMentCModel *departMent = [NSEntityDescription
//                                      insertNewObjectForEntityForName:@"HQDepartMentCModel"
//                                      inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    departMent.companyId      = [[dic objectForKey:@"companyID"] nullProcess];
//    departMent.departmentName = [[dic objectForKey:@"departmentName"] nullProcess];
//    departMent.id             = [[dic objectForKey:@"id"] nullProcess];
//    departMent.remark         = [[dic objectForKey:@"remark"] nullProcess];
//    departMent.isDefault         = [[dic objectForKey:@"isDefault"] nullProcess];
//    
//    return departMent;
//}

//删除
//- (void)deleteUserData
//{
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchUserData]];
//    if (array.count > 0){
//        for (HQUserLoginCModel *userLogin in array) {
//            
//            [self.appDelegate.managedObjectContext deleteObject:userLogin];
//        }
//    }
//}


//查找
- (NSArray *)fetchUserData;
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HQUserLoginCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
//    NSPredicate *pr = [NSPredicate predicateWithFormat:@"userID = %@", userID];
//    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:NO];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
//    [request setPredicate:nil];
//    [request setSortDescriptors:nil];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    
    return arr;
}


//查找文件
- (NSMutableArray *)fetchDocument:(NSNumber *)employId;
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HQDocunmentCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"employId = %@", employId];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"employId" ascending:NO];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //    [request setPredicate:nil];
    //    [request setSortDescriptors:nil];
    
    
    [request setPredicate:pr];
    [request setSortDescriptors:@[sort]];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }

    NSMutableArray * arrs = [NSMutableArray arrayWithArray:arr];
    
    
    return arrs;
}



//查找
- (NSArray *)fetchUserWithTelphone:(NSString *)telphone
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HQUserCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"telphone = %@", telphone];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"telphone" ascending:NO];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:pr];
    [request setSortDescriptors:@[sort]];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    
    return arr;
}


//更改
- (void)updateMusicWithSongName:(NSString *)songName
                    newSongName:(NSString *)newSongName
                  newSingerName:(NSString *)newSingerName
                         newUrl:(NSString *)newUrl{
    
}

- (NSMutableArray *)queryCustomerWithEmployeeID:(NSNumber *)emplyeeID {
    

    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"HQCustomerCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
    NSPredicate *pr = [NSPredicate predicateWithFormat:@"employeeID = %@", emplyeeID];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:NO];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    //    [request setPredicate:nil];
    //    [request setSortDescriptors:nil];
    
    
    [request setPredicate:pr];
    [request setSortDescriptors:@[sort]];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    NSMutableArray * arrs = [NSMutableArray arrayWithArray:arr];
    
    
    return arrs;
    
}


//保存用户员工数据
//- (void)saveUserInfoWith:(NSDictionary *)employDic
//{
//    HQEmployCModel *employ = [self saveEmployWithDic:employDic];
//    
//    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchUserData]];
//    
//    if (array.count != 1){
//        HQLog(@"没有或有多个数据，应该只有一个");
//        return;
//    }
//    
//    HQUserLoginCModel *userLogin = [array firstObject];
//    //个人信息
//    userLogin.employee = employ;
//
////    [self.appDelegate saveContext];
//    
//}


/*******************新存储*********************/


/** 保存布局 */
//- (void)saveLayoutWithDic:(NSDictionary *)dic{
//    
//    if (dic == nil) {
//        return ;
//    }
//    
//    if (![dic isKindOfClass:[NSDictionary class]]) {
//        return ;
//    }
//    
//    HQCustomLayoutCModel *layoutOld = [self fetchLayoutWithBean:[[dic objectForKey:@"bean"] nullProcess]];
//    
//    if (layoutOld) {
//        
//        // 删除老版本
//        [self.appDelegate.managedObjectContext deleteObject:layoutOld];
//    }
//    
//    HQCustomLayoutCModel *layout = [NSEntityDescription
//                                  insertNewObjectForEntityForName:@"HQCustomLayoutCModel"
//                                  inManagedObjectContext:self.appDelegate.managedObjectContext];
//    
//    layout.bean    = [[dic objectForKey:@"bean"] nullProcess];
//    layout.title          = [[dic objectForKey:@"title"] nullProcess];
//    layout.version    = [[dic objectForKey:@"version"] nullProcess];
//    layout.layout  = [[dic objectForKey:@"layout"] nullProcess];
//    
//    [self.appDelegate saveContext];
//}


/** 找到布局 */
//- (HQCustomLayoutCModel *)fetchLayoutWithBean:(NSString *)string{
//    
//    // 过滤条件  此处的过滤条件不知为什么不正确 有待研究
//    // 已解决 下面为正确代码 predicateWithFormat：后面不用stringWithFormat:
//    NSPredicate *pr = [NSPredicate predicateWithFormat:@"bean = %@",string];
////    NSPredicate *pr = nil;
//    
//    // 符合条件的数据
//    NSMutableArray *array = [NSMutableArray arrayWithArray:
//                             [self fetchDataWithClass:@"HQCustomLayoutCModel" predicate:pr sortDescriptor:nil]];
//    
//    if (array.count <= 0) {
//        return nil;
//    }
//    
////    HQCustomLayoutCModel *layout = nil;
////    
////    for (HQCustomLayoutCModel *model in array) {
////        
////        if ([model.bean isEqualToString:string]) {
////            layout = model;
////            break;
////        }
////    }
//    
////    return layout;
//    return [array firstObject];
//    
//}


/** 保存文件信息 */
- (void)saveFileWithDic:(NSDictionary *)dic{
    
    if (dic == nil) {
        return ;
    }
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return ;
    }
    
    
    TFFileCModel *file = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"TFFileCModel"
                                    inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    file.fileId = [[dic objectForKey:@"fileId"] nullProcess];
    file.fileUrl = [[dic objectForKey:@"fileUrl"] nullProcess];
    file.fileSize = [[dic objectForKey:@"fileSize"] nullProcess];
    file.fileName = [[dic objectForKey:@"fileName"] nullProcess];
    file.filePath = [[dic objectForKey:@"filePath"] nullProcess];
    file.fileType = [[dic objectForKey:@"fileType"] nullProcess];
    
    [self.appDelegate saveContext];

}


/** 找到所有下载文件 */
- (NSArray *)fetchFiles{
    
    // 符合条件的数据
    NSMutableArray *array = [NSMutableArray arrayWithArray:
                             [self fetchDataWithClass:@"TFFileCModel" predicate:nil sortDescriptor:nil]];
    
    if (array.count <= 0) {
        return nil;
    }
    
    return array;
    
}

/** 删除某条文件 */
- (void)removeFileWithFileId:(NSString *)fileId{
    
    // 1. 实例化查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TFFileCModel"];
    
    
    // 2. 设置谓词条件
    request.predicate = [NSPredicate predicateWithFormat:@"fileId = %@",fileId];
    
    
    // 3. 由上下文查询数据
    NSArray *result = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    
    
    // 4. 输出结果
    for (TFFileCModel *file in result) {
        
        // 删除一条记录
        [self.appDelegate.managedObjectContext deleteObject:file];
        
        break;
    }
    
    
    // 5. 通知_context保存数据
    if ([self.appDelegate.managedObjectContext save:nil]) {
        
        HQLog(@"删除成功");
        
    } else {
        
        HQLog(@"删除失败");
        
    }
    
}


#pragma mark - 保存当前登录员工信息
- (void)saveCurrentLoginEmployeeWithDic:(NSDictionary *)loginInfo
{
    
    if (loginInfo == nil) {
        return;
    }
    
    if (![loginInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchCurrentEmployeeData]];
    
    if (array.count > 0){
        HQLog(@"已有重复数据");
        [self deleteCurrentEmployeeData];
    }
    
    
    TFUserLoginCModel *userLogin = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"TFUserLoginCModel"
                                    inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    // token
    userLogin.token = [NSString stringWithFormat:@"%@",[[loginInfo objectForKey:@"token"] nullProcess]];
    
    // isLogin
    userLogin.isLogin = [NSString stringWithFormat:@"%@",[[loginInfo objectForKey:@"isLogin"] nullProcess]];
    
    // 员工信息
    userLogin.employee = [self saveCurrentEmployeeWithDic:[[loginInfo objectForKey:@"employee"] nullProcess]];
    // 公司信息
    userLogin.company = [self saveCurrentCompanyWithDict:[[loginInfo objectForKey:@"company"] nullProcess]];
    
    // 部门
    NSArray *departments = [[loginInfo objectForKey:@"departments"] nullProcess];

    for (NSDictionary *dic in departments) {


        if (dic && ![dic isKindOfClass:[NSNull class]]) {
            
            [userLogin addDepartmentsObject:[self saveCurrentDepartmentWithDict:dic]];
            
        }

    }

    [self.appDelegate saveContext];
}


//查找
- (NSArray *)fetchCurrentEmployeeData
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TFUserLoginCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    
    return arr;
}

//删除
- (void)deleteCurrentEmployeeData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchCurrentEmployeeData]];
    if (array.count > 0){
        for (TFUserLoginCModel *userLogin in array) {
            
            [self.appDelegate.managedObjectContext deleteObject:userLogin];
        }
        [self.appDelegate saveContext];
    }
}

/** 退出登录修改登录状态 */
- (void)logoutUpdataIsLogin{
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchCurrentEmployeeData]];
    if (array.count > 0){
        for (TFUserLoginCModel *userLogin in array) {
            
            userLogin.isLogin = @"0";
            
        }
        [self.appDelegate saveContext];
    }
    
//    HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
//    HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
//    userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
}

/** 修改员工的电话 */
- (void)saveEmployeePhone:(NSString *)phone{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TFEmployeeCModel"];
    
    //查询我们可以添加查询条件
    //没有任何条件就是将所有的数据都查询出来
    
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    //修改
    for (TFEmployeeCModel *stu in resArray) {
        stu.phone = TEXT(phone);
    }
    
    //保存
    [self.appDelegate saveContext];
    
}

/** 修改员工的心情和签名 */
- (void)saveEmployeeMood:(NSString *)mood sign:(NSString *)sign{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TFEmployeeCModel"];
    
    //查询我们可以添加查询条件
    //没有任何条件就是将所有的数据都查询出来
    
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    //修改
    for (TFEmployeeCModel *stu in resArray) {
        stu.mood = TEXT(mood);
        stu.sign = TEXT(sign);
    }
    
    //保存
    [self.appDelegate saveContext];
    
}

/** 保存职员信息 */
- (TFEmployeeCModel *)saveCurrentEmployeeWithDic:(NSDictionary *)employDic
{
    if (employDic == nil) {
        return nil;
    }
    
    if (![employDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    
    TFEmployeeCModel *employ = [NSEntityDescription
                              insertNewObjectForEntityForName:@"TFEmployeeCModel"
                              inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    
    employ.id      = [[employDic objectForKey:@"id"] nullProcess];
    employ.post_name      = [[employDic objectForKey:@"post_name"] nullProcess];
    employ.employee_name      = [[employDic objectForKey:@"name"]?:[employDic objectForKey:@"employee_name"] nullProcess];
    employ.picture      = [[employDic objectForKey:@"picture"] nullProcess];
    employ.phone      = [[employDic objectForKey:@"phone"] nullProcess];
    employ.sign_id      = [[employDic objectForKey:@"sign_id"] nullProcess];
    employ.sex      = [[[employDic objectForKey:@"sex"] nullProcess] description];
    employ.sign      = [[employDic objectForKey:@"sign"] nullProcess];
    employ.microblog_background      = [[employDic objectForKey:@"microblog_background"] nullProcess];
    employ.birth      = [[[employDic objectForKey:@"birth"] nullProcess] description];
    employ.mobile_phone      = [[employDic objectForKey:@"mobile_phone"] nullProcess];
    employ.region      = [[employDic objectForKey:@"region"] nullProcess];
    employ.role_id      = [[employDic objectForKey:@"role_id"] nullProcess];
    employ.mood      = [[employDic objectForKey:@"mood"] nullProcess];
    employ.email      = [[employDic objectForKey:@"email"] nullProcess];
    
    
    
    return employ;
}

/** 保存公司 */
- (TFCompanyCModel *)saveCurrentCompanyWithDict:(NSDictionary *)dict{
    
    if (dict == nil) {
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    
    TFCompanyCModel *company = [NSEntityDescription
                                insertNewObjectForEntityForName:@"TFCompanyCModel"
                                inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    company.website      = [[dict objectForKey:@"website"] nullProcess];
    company.address      = [[dict objectForKey:@"address"] nullProcess];
    company.phone      = [[dict objectForKey:@"phone"] nullProcess];
    company.company_name      = [[dict objectForKey:@"company_name"] nullProcess];
    company.id      = [[dict objectForKey:@"id"] nullProcess];
    company.status      = [[[dict objectForKey:@"status"] nullProcess] description];
    company.logo      = [[dict objectForKey:@"logo"] nullProcess];
    company.local_im_address      = [[dict objectForKey:@"local_im_address"] nullProcess];
    
    return company;
}


/** 保存部门 */
- (TFDepartmentCModel *)saveCurrentDepartmentWithDict:(NSDictionary *)dict{
    
    if (dict == nil) {
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    
    TFDepartmentCModel *department = [NSEntityDescription
                                insertNewObjectForEntityForName:@"TFDepartmentCModel"
                                inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    department.parent_id      = [[[dict objectForKey:@"parent_id"] description] nullProcess];
    department.id      = [[dict objectForKey:@"id"] nullProcess];
    department.department_name      = [[dict objectForKey:@"department_name"] nullProcess];
    department.status      = [[[dict objectForKey:@"status"] nullProcess] description];
    department.is_main      = [[[dict objectForKey:@"is_main"] nullProcess] description];
    
    return department;
}

/** 更新公司员工列表 */
- (void)updataEmployeesWithEmployees:(NSArray *)employees{
    
    
    
    if (employees == nil || employees.count == 0) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchCurrentEmployeeData]];
    
    
    for (TFUserLoginCModel *userLogin in array) {
        
        // 先删除
        for (TFEmployeeCModel *employee in userLogin.employees) {
            [self.appDelegate.managedObjectContext deleteObject:employee];
        }
        
        // 添加员工
        for (NSDictionary *dic in employees) {
            
            if (dic && ![dic isKindOfClass:[NSNull class]]) {
                
                [userLogin addEmployeesObject:[self saveCurrentEmployeeWithDic:dic]];
                
            }
            
        }
        
    }
    
    [self.appDelegate saveContext];
}


/** 某一个员工 */
- (TFEmployeeCModel *)fetchEmployeeDataWithEmployeeId:(NSNumber *)employeeId signId:(NSNumber *)signId
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TFUserLoginCModel" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSArray * arr = [self.appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (arr == nil) {
        HQLog(@"没有搜到");
    }
    TFEmployeeCModel *desitnation = nil;
    
    for (TFUserLoginCModel *login in arr) {
        
        for (TFEmployeeCModel *em in login.employees) {
            
            if (employeeId) {
                
                if ([em.id isEqualToNumber:employeeId]) {
                    
                    desitnation = em;
                    break;
                }
                if ([em.sign_id isEqualToNumber:signId]) {
                    
                    desitnation = em;
                    break;
                }
            }
            
        }
    }
    
    return desitnation;
}


@end
