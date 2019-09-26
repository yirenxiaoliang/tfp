//
//  TFProjParticipantModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjParticipantModel.h"

@implementation TFProjParticipantModel

+(HQEmployModel *)employModelForProjParticipantModel:(TFProjParticipantModel *)model{
    
    HQEmployModel *employ = [[HQEmployModel alloc] init];
    
    employ.id = model.employeeId;
    employ.employeeName = model.employeeName;
    employ.photograph = model.photograph;
    employ.isCreator = model.isCreator;
    employ.isPrincipal = model.isPrincipal;
    employ.companyId = model.companyId;
    employ.employeeStatus = model.employeeStatus;
    
    return employ;
}


@end
