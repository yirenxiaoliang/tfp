//
//  TFPCRuleModel.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCRuleModel.h"

@implementation TFPCRuleModel

/**
 //    "outwokerStatus ："0"                //允许外勤打开状态 0否  1是
 //    "faceStatus":"0"                     //人脸识别打开  0否  1是
 //    "autoStatus": "0"                  //法定节假日自动排休   0否 1是
 //    "attendanceType":"0",              //0固定  1排班  2自由
 */
-(instancetype)init{
    if (self = [super init]) {
        self.outwokerStatus = @"0";
        self.faceStatus = @"0";
        self.autoStatus = @"0";
        self.attendanceType = @"0";
    }
    return self;
}

@end
