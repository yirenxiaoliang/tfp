//
//  HQGetVerificationCodeRequestModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/10/9.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface HQGetVerificationCodeRequestModel : JSONModel


/**
 * 手机号码
 */
//@property (strong, nonatomic) NSString *telephoneNum;



/**
 * 验证码类型:0:常用验证模板；1:邀请加入公司；2:注册公司；3:更换登录账号
 */
@property (assign, nonatomic) NSInteger codeType;


/**
 * 手机号码
 */
@property (strong, nonatomic) NSMutableArray *telephones;


/**
 * 是否存在改用户 没登录传0，已登录传1
 */
@property (assign, nonatomic) NSNumber *isUserExist;

/**
 * 用户ID
 */
//@property (strong, nonatomic) NSNumber <Optional> *userId;


/**
 * 公司ID
 */
//@property (strong, nonatomic) NSNumber <Optional> *companyId;





@end
