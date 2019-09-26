//
//  TFEmpInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmpEmployeeInfoModel.h"
#import "TFEmpDepartmentInfoModel.h"
#import "TFEmpCompanyInfoModel.h"


@interface TFEmpInfoModel : JSONModel

//{
//    "employeeInfo" : null,
//    "departmentInfo" : [
//    
//    ],
//    "fabulous_status" : 0,
//    "companyInfo" : {
//        "address" : "",
//        "website" : "",
//        "phone" : "",
//        "company_name" : "西楚",
//        "id" : 5,
//        "status" : "0",
//        "logo" : ""
//    },
//    "photo" : [
//    
//    ],
//    "fabulous_count" : 0
//}

@property (nonatomic, strong) TFEmpEmployeeInfoModel <Optional>*employeeInfo;

@property (nonatomic, strong) NSArray <TFEmpDepartmentInfoModel,Optional>*departmentInfo;

@property (nonatomic, strong) NSNumber <Optional>*fabulous_status;

@property (nonatomic, strong) TFEmpCompanyInfoModel <Optional>*companyInfo;

@property (nonatomic, strong) NSArray <Optional>*photo;

@property (nonatomic, strong) NSNumber <Optional>*fabulous_count;

@end
