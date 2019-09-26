//
//  TFChangeHelper.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChangeHelper.h"

@implementation TFChangeHelper


+(HQEmployModel *)employeeForNormalPeople:(TFNormalPeopleModel *)normalModel{
    
    HQEmployModel *model = [[HQEmployModel alloc] init];
    
    model.id = normalModel.id;
    model.employee_id = normalModel.id;
    model.picture = normalModel.picture;
    model.employeeName = normalModel.name;
    model.employee_name = normalModel.name;
    model.name = normalModel.name;
    model.photograph = normalModel.picture;
    model.type = normalModel.type;
    model.value = normalModel.value;
    
    return model;
}


+(TFDepartmentModel *)departmentForNormalDepartment:(TFNormalPeopleModel *)normalModel{
    
    TFDepartmentModel *model = [[TFDepartmentModel alloc] init];
    model.id = normalModel.id;
    model.name = normalModel.name;
    
    return model;
}

+(TFNormalPeopleModel *)normalPeopleForEmployee:(HQEmployModel *)normalModel{
    
    TFNormalPeopleModel *model = [[TFNormalPeopleModel alloc] init];
    model.type = @1;
    model.name = normalModel.employeeName;
    model.picture = normalModel.picture;
    model.id = normalModel.id;
    model.checked = @1;
    
    return model;
}

+ (HQEmployModel *)tfEmployeeToHqEmployee:(TFEmployModel *)model{
    
    HQEmployModel * employee = [[HQEmployModel alloc] init];
    
    employee.selectState = model.select;
    employee.employee_name = model.employee_name?:model.name;
    employee.employeeName = model.employee_name?:model.name;
    employee.id = model.id?model.id:model.employee_id;
    employee.employeeId = model.id?model.id:model.employee_id;
    employee.picture = model.picture;
    employee.photograph = model.picture;
    employee.position = model.post_name;
    employee.telephone = model.phone;
    employee.gender = model.sex;
    employee.sign_id = model.sign_id;
    employee.microblog_background = model.microblog_background;
    employee.value = model.value;
    
    return employee;
}

+ (TFEmployModel *)hqEmployeeToTfEmployee:(HQEmployModel *)employee{
    TFEmployModel * model = [[TFEmployModel alloc] init];

    model.select = employee.selectState;
    model.employee_name = employee.employee_name?:employee.employeeName;
    model.name = employee.employee_name?:employee.employeeName;
    model.id = employee.id?:employee.employeeId;
    model.employee_id = employee.id?:employee.employeeId;
    model.picture = employee.picture?:employee.photograph;
    model.post_name = employee.position;
    model.phone = employee.telephone;
    model.sex = employee.gender;
    model.sign_id = employee.sign_id;
    model.microblog_background = employee.microblog_background;

    return model;
}

@end
