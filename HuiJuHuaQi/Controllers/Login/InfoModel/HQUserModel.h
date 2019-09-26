//
//  HQUserModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/10/28.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@interface HQUserModel : HQBaseVoModel

/** 用户注册号，一般为用户的注册手机号 */
@property (nonatomic, copy) NSString <Optional>*userCode;
/** 手机号 */
@property (nonatomic, copy) NSString <Optional>*telephone;
/** 激活 */
@property (nonatomic, assign) NSNumber <Optional>*isActive;
/** 是否有密码 */
@property (nonatomic, strong) NSNumber <Optional>*passWord;
/** 用户姓名 */
@property (nonatomic, copy) NSString <Optional>*userName;
/** 头像  */
@property (nonatomic, copy) NSString <Optional>*photograph;
/** mobile端的请求验证码 */
@property (nonatomic, copy) NSString <Optional>*token;
/** token校验时间 */
@property (nonatomic, strong) NSNumber <Optional>*tokenValidTime;
/** 用户昵称 */
@property (nonatomic, copy) NSString <Optional>*nickName;

/** 设备号类型:1为Android 2为IOS-1为其设备 */
@property (nonatomic, assign) NSNumber <Optional>*clientType;

/** 设备号,只记录最后一次登录时的手机设备号id */
@property (nonatomic, copy) NSString <Optional>*latelyClientId;

/** 最后一次登录的公司ID */
@property (nonatomic, strong) NSNumber <Optional>*latelyCompanyId;
/** 邀请加入的公司ID */
@property (nonatomic, strong) NSNumber <Optional>*inviteCompanyId;
/** 员工id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;


@end
