//
//  TFPersonInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/6/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFPersonInfoModel : JSONModel

//"data" : {
//    "gender" : 0,
//    "departmentName" : "陈宇亮的团队",
//    "position" : null,
//    "photograph" : "http:\/\/192.168.1.172:9400\/6\/02e651d66d4827",
//    "userName" : "chenyuliang",
//    "region" : null,
//    "companyName" : "陈宇亮的团队",
//    "email" : "",
//    "telephone" : "15974267842"
//},

@property (nonatomic, strong) NSNumber <Optional>*gender; //性别

@property (nonatomic, copy) NSString <Optional>*departmentName; //部门名

@property (nonatomic, copy) NSString <Optional>*position; //职位

@property (nonatomic, copy) NSString <Optional>*photograph; //头像地址

@property (nonatomic, copy) NSString <Optional>*imUserName; //用户名

@property (nonatomic, copy) NSString <Optional>*region; //地区

@property (nonatomic, copy) NSString <Optional>*companyName; //公司名

@property (nonatomic, copy) NSString <Optional>*email; //email

@property (nonatomic, copy) NSString <Optional>*telephone; //手机号

@property (nonatomic, copy) NSString <Optional>*employeeName; //

@property (nonatomic, copy) NSString <Optional>*birthday; //

@property (nonatomic, copy) NSString <Optional>*mobilePhoto; //

@property (nonatomic, copy) NSString <Optional>*microblogBackground;

@end
