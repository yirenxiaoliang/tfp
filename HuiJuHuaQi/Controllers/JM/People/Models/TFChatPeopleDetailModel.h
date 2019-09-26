//
//  TFChatPeopleDetailModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQDepartmentModel.h"
#import "TFRoleModel.h"
#import "TFPositionModel.h"

@interface TFChatPeopleDetailModel : JSONModel

/** employeeId */
@property (nonatomic, strong) NSNumber <Optional>*id;

/** employeeId */
@property (nonatomic, strong) NSArray <HQDepartmentModel,Optional>*departmentList;

/** employeeId */
@property (nonatomic, copy) NSString <Optional>*employeeNumber;

/** employeeId */
@property (nonatomic, copy) NSString <Optional>*employeeName;

/** departmentName */
@property (nonatomic, copy) NSString <Optional>*departmentName;

/** companyName */
@property (nonatomic, copy) NSString <Optional>*companyName;

/** email */
@property (nonatomic, copy) NSString <Optional>*email;

/** telephone */
@property (nonatomic, copy) NSString <Optional>*telephone;

/** role */
@property (nonatomic, strong) TFRoleModel <TFRoleModel,Optional>*role;

/** position */
@property (nonatomic, strong) TFPositionModel <TFPositionModel,Optional>*position;


@end
