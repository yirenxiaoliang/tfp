//
//  TFEmpCompanyInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmpCompanyInfoModel @end

@interface TFEmpCompanyInfoModel : JSONModel

//{
//    "address" : "",
//    "website" : "",
//    "phone" : "",
//    "company_name" : "西楚",
//    "id" : 5,
//    "status" : "0",
//    "logo" : ""
//},

@property (nonatomic, copy) NSString <Optional>*address;

@property (nonatomic, copy) NSString <Optional>*website;

@property (nonatomic, copy) NSString <Optional>*phone;

@property (nonatomic, copy) NSString <Optional>*company_name;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*status;

@property (nonatomic, copy) NSString <Optional>*logo;


@end
