//
//  TFFinishPersonDataController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQUserModel.h"

typedef enum {
    FinishDataType_joinCompany,
    FinishDataType_person,
    FinishDataType_company,
    FinishDataType_employee// 邀请码登录完善资料
}FinishDataType;

@interface TFFinishPersonDataController : HQBaseViewController

/** type */
@property (nonatomic, assign) FinishDataType type;

/** user */
@property (nonatomic, strong) HQUserModel *user;

/** userId */
@property (nonatomic, copy) NSString *userId;
/** companyId */
@property (nonatomic, copy) NSString *companyId;

@end
