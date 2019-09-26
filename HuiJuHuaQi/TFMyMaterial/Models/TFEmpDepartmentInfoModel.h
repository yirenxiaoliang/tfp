//
//  TFEmpDepartmentInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmpDepartmentInfoModel @end

@interface TFEmpDepartmentInfoModel : JSONModel

//{
//    "parent_id" : "",
//    "is_main" : "0",
//    "department_name" : "西楚",
//    "id" : 1,
//    "status" : "0"
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*parent_id;

@property (nonatomic, copy) NSString <Optional>*is_main;

@property (nonatomic, copy) NSString <Optional>*department_name;

@property (nonatomic, copy) NSString <Optional>*status;

@end
