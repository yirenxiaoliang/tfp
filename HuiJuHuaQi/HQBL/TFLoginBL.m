//
//  TFLoginBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFLoginBL.h"
#import "HQCompanyModel.h"
#import "TFSocketManager.h"

@interface TFLoginBL ()


@end

@implementation TFLoginBL

/**  新注册
 *
 * @param companyName 用户名
 * @param userName 用户姓名
 * @param password 密码
 * @param telephone 电话
 * @param inviteCode 邀请码
 *
 */
-(void)requestRegisterWithCompanyName:(NSString *)companyName userName:(NSString *)userName password:(NSString *)password telephone:(NSString *)telephone inviteCode:(NSString *)inviteCode{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (companyName) {
        [dic setObject:companyName forKey:@"company_name"];
    }
    if (userName) {
        [dic setObject:userName forKey:@"user_name"];
    }
    
    if (password) {
        [dic setObject:[HQHelper stringForMD5WithString:password] forKey:@"user_pwd"];
    }
    
    if (telephone) {
        [dic setObject:telephone forKey:@"phone"];
    }
    if (inviteCode) {
        [dic setObject:inviteCode forKey:@"invite_code"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_userNewRegister];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_userNewRegister
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/**  注册
 *
 * @param userName 用户名
 * @param password 密码
 *
 */
-(void)requestRegisterWithUserName:(NSString *)userName password:(NSString *)password{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"loginName"];
    }
    
    if (password) {
        [dic setObject:[HQHelper stringForMD5WithString:password] forKey:@"loginPwd"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_userRegister];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_userRegister
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/**  登录
 *
 * @param userName 用户名
 * @param password 密码
 * @param userCode 验证码
 *
 */
-(void)requestLoginWithUserName:(NSString *)userName password:(NSString *)password userCode:(NSString *)userCode{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"userName"];
    }
    
    if (password) {
        [dic setObject:[HQHelper stringForMD5WithString:password] forKey:@"passWord"];
    }
    
    if (userCode) {
        [dic setObject:userCode forKey:@"userCode"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_userLogin];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_userLogin
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  获取验证码
 *
 * @param userName 用户名（手机号）
 * @param type 验证码用途  0通用 1注册 2改密 3更改手机号
 *
 */
-(void)requestGetVerificationWithUserName:(NSString *)userName type:(NSNumber *)type{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"telephone"];
    }
    if (type) {
        [dic setObject:type forKey:@"type"];
    }
    [dic setObject:@"zh" forKey:@"language"];
    
    
    NSString *url = [super urlFromCmd:HQCMD_sendVerifyCode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_sendVerifyCode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/**  注册/忘记密码验证
 *
 * @param userName 用户名
 * @param code 验证码
 * @param type 验证码用途 //0通用 1注册 2改密
 *
 */
-(void)requestVerificationWithUserName:(NSString *)userName code:(NSString *)code type:(NSNumber *)type{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"telephone"];
    }
    if (code) {
        [dic setObject:code forKey:@"smsCode"];
    }
    if (type) {
        [dic setObject:type forKey:@"type"];
    }

    
    NSString *url = [super urlFromCmd:HQCMD_verifyVerificationCode];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_verifyVerificationCode
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  忘记密码
 *
 * @param userName 用户名
 * @param newPassword 新密码
 *
 */
-(void)requestForgetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"loginName"];
    }
    if (newPassword) {
        [dic setObject:[HQHelper stringForMD5WithString:newPassword] forKey:@"loginPwd"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_modifyPassWord];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_modifyPassWord
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/**  扫一扫提交唯一编码和用户名
 *
 * @param userName 用户名
 * @param uniqueCode 唯一编码
 *
 */
-(void)requestScanWithUserName:(NSString *)userName uniqueCode:(NSString *)uniqueCode{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (userName) {
        [dic setObject:userName forKey:@"userName"];
    }
    
    if (uniqueCode) {
        [dic setObject:uniqueCode forKey:@"id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_scanCodeSubmit];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_scanCodeSubmit
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/**  初始化公司
 *
 * @param dict 公司信息
 *
 */
-(void)requestSetupCompanyInfoWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_setupCompanyInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_setupCompanyInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  初始化员工
 *
 * @param dict 员工信息
 *
 */
-(void)requestSetupEmployeeInfoWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_setupEmployeeInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_setupEmployeeInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  公司列表
 *
 *
 */
-(void)requestGetCompanyList{
    
    NSString *url = [super urlFromCmd:HQCMD_getCompanyList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:@{}
                                            cmdId:HQCMD_getCompanyList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**  切换公司
 *
 * @param companyId 公司id
 *
 */
-(void)requestChangeCompanyWithCompanyId:(NSString *)companyId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (companyId) {
        [dic setObject:companyId forKey:@"company_id"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_changeCompany];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_changeCompany
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}



/**  获取登录后当前员工和公司信息
 *
 *
 */
-(void)requestGetEmployeeInfoAndCompanyInfo{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_getEmployeeAndCompanyInfo];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getEmployeeAndCompanyInfo
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** ----------上传 DeviceToken--------- */
-(void)requestUploadDeviceToken{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceToken];
    if (token) {
        [dict setObject:token forKey:@"device_token"];
    }else{
        return;
    }
    
    NSString *url = [super urlFromCmd:HQCMD_uploadDeviceToken];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_uploadDeviceToken
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/** ----------新获取员工列表--------- */
-(void)requestEmployeeList{
    
    NSString *url = [super urlFromCmd:HQCMD_employeeList];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_employeeList
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**
 * 获取最近登录公司密码策略
 */
-(void)requestGetCompanySetWithPhone:(NSString *)phone{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (phone) {
        [dic setObject:phone forKey:@"phone"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getCompanySet];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getCompanySet
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}

/**
 * 更换手机号
 */
-(void)requestChangeTelephoneWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (phone) {
        [dic setObject:phone forKey:@"phone"];
    }
    if (verifyCode) {
        [dic setObject:verifyCode forKey:@"sms_code"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_changeTelephone];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dic
                                            cmdId:HQCMD_changeTelephone
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/**
 * 获取banner
 */
-(void)requestGetBanner{
    
    NSString *url = [super urlFromCmd:HQCMD_getBanner];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:nil
                                            cmdId:HQCMD_getBanner
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/** 获取名片样式 */
-(void)requestGetCardStyleWithEmployeeId:(NSNumber *)employeeId{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (employeeId) {
        [dic setObject:employeeId forKey:@"employeeId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getCardStyle];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getCardStyle
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/** 保存名片样式 */
-(void)requestSaveCardStyleWithDict:(NSDictionary *)dict{
    
    NSString *url = [super urlFromCmd:HQCMD_saveCardStyle];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"SELFPOST"
                                     requestParam:dict
                                            cmdId:HQCMD_saveCardStyle
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
            case HQCMD_userLogin:// 登录
            {
                NSDictionary *dict = data[kData];
                NSString *domain = [dict valueForKey:@"domain"];
                if (domain) {
                    [[NSUserDefaults standardUserDefaults] setObject:domain forKey:UserPictureDomain];
                }
                
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_userNewRegister:// 新注册
            {
                
                NSDictionary *dict = data[kData];
                if (dict) {// 存在
                    //存入数据库
                    HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                    [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
                    HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                    userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_userRegister:// 注册
            {
                
                NSDictionary *dict = data[kData];
                
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];

                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_sendVerifyCode:// 验证码
            {
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_scanCodeSubmit:// 扫一扫提交
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_verifyVerificationCode:// 验证验证码
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
                
            case HQCMD_modifyPassWord:// 修改密码
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data];
            }
                break;
            case HQCMD_setupCompanyInfo:// 初始化公司
            {
                NSDictionary *dict = data[kData];
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_setupEmployeeInfo:// 初始化员工
            {
                NSDictionary *dict = data[kData];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getCompanyList:// 公司列表
            {
                NSArray *arr = data[kData];
                NSMutableArray *companys = [NSMutableArray array];
                for (NSDictionary *comp in arr) {
                    
                    HQCompanyModel *model = [[HQCompanyModel alloc] initWithDictionary:comp error:nil];
                    [companys addObject:model];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:companys];
            }
                break;
            case HQCMD_changeCompany:// 切换公司
            {
                NSDictionary *dict = data[kData];
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
                
                [[TFSocketManager sharedInstance] loginOutSocket];//发退出企信登陆包
                
            }
                break;
                
            case HQCMD_getEmployeeAndCompanyInfo:// 登录后获取员工及公司信息
            {
                NSDictionary *dict = data[kData];
                
                //存入数据库
                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
                NSMutableDictionary *employeeDict = [NSMutableDictionary dictionary];
                
                HQLog(@"%@",userManager.userLoginInfo.token);
                if (userManager.userLoginInfo.token) {
                    
                    [employeeDict setObject:userManager.userLoginInfo.token forKey:@"token"];
                }
                
                [employeeDict setObject:@"1" forKey:@"isLogin"];
                
                if ([dict valueForKey:@"employeeInfo"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[dict valueForKey:@"employeeInfo"] valueForKey:@"role_type"] forKey:@"RoleType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [employeeDict setObject:TEXT([dict valueForKey:@"employeeInfo"]) forKey:@"employee"];
                }
                if ([dict valueForKey:@"companyInfo"]) {
                    
                    [employeeDict setObject:TEXT([dict valueForKey:@"companyInfo"]) forKey:@"company"];
                    
                    NSDictionary *com = [dict valueForKey:@"companyInfo"];
                    if ([com valueForKey:@"local_im_address"]) {
                        
                        [AppDelegate shareAppDelegate].iMAddress = [com valueForKey:@"local_im_address"];
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setValue:[com valueForKey:@"local_im_address"] forKey:SaveIMAddressKey];
                        [userDefault synchronize];
                    }
                }
                
                if ([dict valueForKey:@"departmentInfo"]) {
                    
                    [employeeDict setObject:TEXT([dict valueForKey:@"departmentInfo"]) forKey:@"departments"];
                }
                
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager saveCurrentLoginEmployeeWithDic:employeeDict];
                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCompanySocketConnect object:nil];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_uploadDeviceToken:// 上传 deviceToken
            {
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
                
            }
                
            case HQCMD_employeeList:// 员工列表
            {
                
                NSArray *arr = data[kData];
                
                //存入数据库
                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
                [coreDataManager updataEmployeesWithEmployees:arr];
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
                
//                NSDictionary *dict = data[kData];
//                //存入数据库
//                HQCoreDataManager *coreDataManager = [HQCoreDataManager defaultCoreDataManager];
//                [coreDataManager saveCurrentLoginEmployeeWithDic:dict];
//                HQUserManager *userManager = [HQUserManager defaultUserInfoManager];
//                userManager.userLoginInfo = [[coreDataManager fetchCurrentEmployeeData] firstObject];
//                
//                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:dict];
            }
                break;
            case HQCMD_getCompanySet:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
                
            }
                break;
            case HQCMD_changeTelephone:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
                
            }
                break;
            case HQCMD_getBanner:{
                NSDictionary *dict = data[kData];
                NSString *str = [dict valueForKey:@"banner"];
                NSArray *arr = @[];
                if (str.length) {
                    arr = [HQHelper dictionaryWithJsonString:str];
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:arr];
                
            }
                break;
            case HQCMD_getCardStyle:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
                
            }
                break;
            case HQCMD_saveCardStyle:{
                
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:data[kData]];
                
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
    
}

@end
