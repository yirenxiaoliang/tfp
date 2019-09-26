//
//  TFCompanyModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFCompanyModel : JSONModel

/** 公司id */
@property (nonatomic, strong) NSNumber *companyId;
/** 公司名称 */
@property (nonatomic, copy) NSString *companyName;
/** 所在地 */
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *addressId;
/** 所在行业 */
@property (nonatomic, copy) NSString *companyIndustry;
@property (nonatomic, copy) NSString *industryId;
/** 创建人 */
@property (nonatomic, copy) NSString *creater;
/** 电话 */
@property (nonatomic, copy) NSString *telephone;
/** 验证码 */
@property (nonatomic, copy) NSString *code;
/** 密码 */
@property (nonatomic, copy) NSString *passWord;

@end
