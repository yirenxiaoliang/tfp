//
//  TFLoginBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"
#import <NetworkExtension/NetworkExtension.h>

@interface TFLoginBL : HQBaseBL

/**  新注册
 *
 * @param companyName 用户名
 * @param userName 用户姓名
 * @param password 密码
 * @param telephone 电话
 * @param inviteCode 邀请码
 *
 */
-(void)requestRegisterWithCompanyName:(NSString *)companyName userName:(NSString *)userName password:(NSString *)password telephone:(NSString *)telephone inviteCode:(NSString *)inviteCode;

/**  注册
 *
 * @param userName 用户名
 * @param password 密码
 *
 */
-(void)requestRegisterWithUserName:(NSString *)userName password:(NSString *)password;


/**  登录
 *
 * @param userName 用户名
 * @param password 密码
 * @param userCode 验证码
 *
 */
-(void)requestLoginWithUserName:(NSString *)userName password:(NSString *)password userCode:(NSString *)userCode;


/**  获取验证码
 *
 * @param userName 用户名（手机号）
 * @param type 验证码用途 //0通用 1注册 2改密
 *
 */
-(void)requestGetVerificationWithUserName:(NSString *)userName type:(NSNumber *)type;


/**  注册/忘记密码验证
 *
 * @param userName 用户名
 * @param code 验证码
 * @param type 验证码用途 //0通用 1注册 2改密
 *
 */
-(void)requestVerificationWithUserName:(NSString *)userName code:(NSString *)code type:(NSNumber *)type;


/**  忘记密码
 *
 * @param userName 用户名
 * @param newPassword 新密码
 *
 */
-(void)requestForgetPasswordWithUserName:(NSString *)userName newPassword:(NSString *)newPassword;


/**  扫一扫提交唯一编码和用户名
 *
 * @param userName 用户名
 * @param uniqueCode 唯一编码
 *
 */
-(void)requestScanWithUserName:(NSString *)userName uniqueCode:(NSString *)uniqueCode;


/**  初始化公司
 *
 * @param dict 公司信息
 *
 */
-(void)requestSetupCompanyInfoWithDict:(NSDictionary *)dict;


/**  初始化员工
 *
 * @param dict 员工信息
 *
 */
-(void)requestSetupEmployeeInfoWithDict:(NSDictionary *)dict;

/**  公司列表
 *
 *
 */
-(void)requestGetCompanyList;

/**  切换公司
 *
 * @param companyId 公司id
 *
 */
-(void)requestChangeCompanyWithCompanyId:(NSString *)companyId;

/**  获取登录后当前员工和公司信息
 *
 *
 */
-(void)requestGetEmployeeInfoAndCompanyInfo;

/** ----------新获取员工列表--------- */
-(void)requestEmployeeList;

/**
 * 获取最近登录公司密码策略
 */
-(void)requestGetCompanySetWithPhone:(NSString *)phone;

/**
 * 更换手机号
 */
-(void)requestChangeTelephoneWithPhone:(NSString *)phone verifyCode:(NSString *)verifyCode;


/**
 * 获取banner
 */
-(void)requestGetBanner;


/** 获取名片样式 */
-(void)requestGetCardStyleWithEmployeeId:(NSNumber *)employeeId;


/** 保存名片样式 */
-(void)requestSaveCardStyleWithDict:(NSDictionary *)dict;













@end
