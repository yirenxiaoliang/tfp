//
//  TFGroupEmployeeModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFGroupEmployeeModel @end

@interface TFGroupEmployeeModel : JSONModel

//{
//    "id" : 12,
//    "account" : "13163739593",
//    "status" : "0",
//    "phone" : "13163739593",
//    "leader" : "0",
//    "sex" : "",
//    "is_enable" : "1",
//    "employee_name" : "阿栋",
//    "picture" : "",
//    "create_by" : "",
//    "is_del" : "0",
//    "microblog_background" : "",
//    "post_id" : "",
//    "mobile_phone" : "",
//    "create_time" : "",
//    "role_id" : -1,
//    "email" : "",
//    "sign" : ""
//},

@property (nonatomic, copy) NSString <Optional>*leader;

@property (nonatomic, copy) NSString <Optional>*is_enable;

@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*employeeName;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, copy) NSString <Optional>*post_id;

@property (nonatomic, copy) NSString <Optional>*phone;

@property (nonatomic, copy) NSString <Optional>*role_id;

@property (nonatomic, copy) NSString <Optional>*mobile_phone;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*email;

@property (nonatomic, copy) NSString <Optional>*account;

@property (nonatomic, copy) NSString <Optional>*status;

@property (nonatomic, copy) NSString <Optional>*sex;

@property (nonatomic, copy) NSString <Optional>*create_by;

@property (nonatomic, copy) NSString <Optional>*is_del;

@property (nonatomic, copy) NSString <Optional>*microblog_background;

@property (nonatomic, copy) NSString <Optional>*create_time;

@property (nonatomic, copy) NSString <Optional>*sign;

@property (nonatomic, strong) NSNumber <Ignore>*selectState;

@property (nonatomic, strong) NSNumber <Optional>*sign_id;

@end
