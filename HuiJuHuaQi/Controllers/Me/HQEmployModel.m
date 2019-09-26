//
//  HQEmployModel.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQEmployModel.h"

@implementation HQEmployModel

//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"name":@"employeeName"}];
//}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.authNames = [NSMutableArray array];
//        [self.authNames addObject:@110];
//    }
//    return self;
//}


+ (HQEmployModel *)employeeWithEmployeeCModel:(TFEmployeeCModel *)employee{
    
    HQEmployModel *model = [[HQEmployModel alloc] init];
    
    model.employee_name = employee.employee_name;
    model.employeeName = employee.employee_name;
    model.employeeId = employee.id;
    model.id = employee.id;
    model.photograph = employee.picture;
    model.telephone = employee.phone;
    model.sign_id = employee.sign_id;
    model.microblog_background = employee.microblog_background;
    model.position = employee.post_name;
    model.gender = @([employee.sex integerValue]);
    
    return model;
}


//+ (TFEmployModel *)hqEmployeeToTfEmployee:(HQEmployModel *)employee{
//    TFEmployModel * model = [[TFEmployModel alloc] init];
//    
//    model.select = employee.selectState;
//    model.employee_name = employee.employee_name?:employee.employeeName;
//    model.id = employee.id?:employee.employeeId;
//    model.picture = employee.picture?:employee.photograph;
//    model.post_name = employee.position;
//    model.phone = employee.telephone;
//    model.sex = employee.gender;
//    model.sign_id = employee.sign_id;
//    model.microblog_background = employee.microblogBackground;
//    
//    return model;
//}

@end
