//
//  TFEmpEmployeeInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmpEmployeeInfoModel @end

@interface TFEmpEmployeeInfoModel : JSONModel

//{
//    "id" : 1,
//    "post_name" : "员工",
//    "phone" : "15974267841",
//    "sex" : "1",
//    "employee_name" : "项羽",
//    "picture" : "http:\/\/192.168.1.9:8080\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1515471361299.201801091217210.jpg",
//    "mood" : "",
//    "microblog_background" : "",
//    "sign_id" : 7,
//    "role_id" : 1,
//    "email" : "",
//    "sign" : ""
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*post_name;

@property (nonatomic, copy) NSString <Optional>*phone;

@property (nonatomic, copy) NSString <Optional>*sex;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, copy) NSString <Optional>*mood;

@property (nonatomic, copy) NSString <Optional>*microblog_background;

@property (nonatomic, strong) NSNumber <Optional>*sign_id;

@property (nonatomic, strong) NSNumber <Optional>*role_id;

@property (nonatomic, copy) NSString <Optional>*email;

@property (nonatomic, copy) NSString <Optional>*sign;

@property (nonatomic, copy) NSString <Optional>*region;

@property (nonatomic, copy) NSString <Optional>*birth;

@property (nonatomic, copy) NSString <Optional>*mobile_phone;

@end
