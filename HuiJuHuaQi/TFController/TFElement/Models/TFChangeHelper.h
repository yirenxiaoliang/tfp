//
//  TFChangeHelper.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNormalPeopleModel.h"
#import "HQEmployModel.h"
#import "TFDepartmentModel.h"

@interface TFChangeHelper : NSObject

+(HQEmployModel *)employeeForNormalPeople:(TFNormalPeopleModel *)normalModel;
+(TFNormalPeopleModel *)normalPeopleForEmployee:(HQEmployModel *)normalModel;

+ (HQEmployModel *)tfEmployeeToHqEmployee:(TFEmployModel *)employee;
+ (TFEmployModel *)hqEmployeeToTfEmployee:(HQEmployModel *)employee;

+(TFDepartmentModel *)departmentForNormalDepartment:(TFNormalPeopleModel *)normalModel;

@end
