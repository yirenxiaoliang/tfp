//
//  TFPeopleBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPeopleBL.h"
#import "HQDepartmentModel.h"
#import "TFPositionModel.h"
#import "TFChatPeopleDetailModel.h"
#import "TFEmployModel.h"
#import "TFDepartmentModel.h"
#import "TFRoleModel.h"
#import "TFDynamicParameterModel.h"

@implementation TFPeopleBL


/** ----------新获取员工列表--------- */
-(void)requestEmployeeListWithDismiss:(NSNumber *)dismiss{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (dismiss) {
        
        [dict setObject:dismiss forKey:@"dismiss"];
    }
    NSString *url = [super urlFromCmd:HQCMD_employeeList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_employeeList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取组织架构树 */
- (void)requestCompanyFrameworkWithCompanyId:(NSString *)companyId dismiss:(NSNumber *)dismiss{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (companyId) {
        
        [dict setObject:companyId forKey:@"companyId"];
    }
    if (dismiss) {
        
        [dict setObject:dismiss forKey:@"dismiss"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_companyFramework];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_companyFramework
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 编辑自己信息 */
-(void)requestUpdateEmployeeWithEmployee:(TFEmployModel *)employee{
    
    
    NSDictionary *dict = @{@"data":[employee toDictionary]};
    
    NSString *url = [super urlFromCmd:HQCMD_updateEmployee];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_updateEmployee
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    [self.tasks addObject:requestItem];
}


/** 修改密码 */
-(void)requestModPassWordWithPassWord:(NSString *)passWord newPassWord:(NSString *)newPassWord{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (passWord) {
        
        [dict setObject:passWord forKey:@"passWord"];
    }
    if (newPassWord) {
        
        [dict setObject:newPassWord forKey:@"newPassWord"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_modPassWrd];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_modPassWrd
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 员工详情 */
-(void)requestEmployeeDetailWithEmployeeId:(NSNumber *)employeeId{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (employeeId) {
        
        [dict setObject:employeeId forKey:@"employee_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_employeeDetail];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_employeeDetail
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}



/** 获取角色列表 http://192.168.1.9:8080/custom-gateway/moduleDataAuth/getRoleGroupList*/
-(void)requsetGetRoleGroupList{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    NSString *url = [super urlFromCmd:HQCMD_getRoleGroupList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getRoleGroupList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/** 组织架构模糊查找 */
-(void)requsetFindByUserNameWithDepartmentId:(NSNumber *)departmentId employeeName:(NSString *)employeeName dismiss:(NSNumber *)dismiss{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (departmentId) {
        [dict setObject:departmentId forKey:@"department_id"];
    }
    if (employeeName) {
        [dict setObject:employeeName forKey:@"employee_name"];
    }
    if (dismiss) {
        [dict setObject:dismiss forKey:@"dismiss"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_findByUserName];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_findByUserName
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** 动态参数 */
-(void)requsetGetSharePersonalFieldsWithBean:(NSString *)bean type:(NSInteger)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (bean) {
        [dict setObject:bean forKey:@"bean"];
    }
    [dict setObject:@(type) forKey:@"type"];
    
    NSString *url = [super urlFromCmd:HQCMD_getSharePersonalFields];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dict
                                            cmdId:HQCMD_getSharePersonalFields
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Response
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
                
            /** ----------------新员工--------------- */
            case HQCMD_employeeList:  // 员工列表
            {
                NSArray *arr = data[kData];
                NSMutableArray *positions = [NSMutableArray array];
                
                for (NSInteger i = 0; i < arr.count; i++) {
                    
                    NSDictionary *employDict = arr[i];
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:employDict error:nil];
                    [positions addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:positions];
            }
                break;
            case HQCMD_companyFramework:  // 组织架构
            {
                
                NSArray *arr = data[kData];
                NSMutableArray *positions = [NSMutableArray array];
                
                for (NSInteger i = 0; i < arr.count; i++) {
                    
                    NSDictionary *employDict = arr[i];
                    TFDepartmentModel *model = [[TFDepartmentModel alloc] initWithDictionary:employDict error:nil];
                    [positions addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:positions];
            }
                break;
            case HQCMD_updateEmployee:// 修改人员
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_modPassWrd:// 修改密码
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_uploadFile:// 上传文件
            case HQCMD_ChatFile:
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
            case HQCMD_ImageFile:// 上传文件
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
                
            case HQCMD_employeeDetail:// 员工详情
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
                
            case HQCMD_getRoleGroupList:// 角色组列表
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFRoleModel *model = [[TFRoleModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
            case HQCMD_getSharePersonalFields:// 动态参数列表
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFDynamicParameterModel *model = [[TFDynamicParameterModel alloc] initWithDictionary:dict error:nil];
                    if (model) {
                        [models addObject:model];
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:models];
            }
                break;
                
            case HQCMD_findByUserName:// 组织架构模糊查找
            {
                NSArray *arr = data[kData];
                
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
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
