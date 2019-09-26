//
//  TFPCRuleModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFPCRuleModel : JSONModel

//{
//    "name":"考勤组A",                //考勤组的名字
//    "mustAttendance":[],              //必须考勤人员 数组对象
//    " noAttendance": "4,5,6",         //无需考勤人员  多个逗号分隔 员工ID
//    "mustPunchcardDate":              //必须打卡日期
//    "noPunchcardDate":                //不用打卡日期
//    "reslutData": []                  //选择结果数据结构
//    "attendanceStartTime":            //考勤开始时间
//    "attendanceAddress ：[]            //考勤地址数组
//    "attendanceWifi ：[]               //考勤wifi数组
//    "outwokerStatus ："0"                //允许外勤打开状态 0否  1是
//    "faceStatus":"0"                     //人脸识别打开  0否  1是
//    "autoStatus": "0"                  //法定节假日自动排休   0否 1是
//    "attendanceType":"0",              //0固定  1排班  2自由
//}

@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, strong) NSMutableArray <Optional>*mustAttendance;
@property (nonatomic, copy) NSString <Optional>*noAttendance;
@property (nonatomic, copy) NSString <Optional>*attendanceType;
@property (nonatomic, copy) NSString <Optional>*autoStatus;

@property (nonatomic, strong) NSMutableArray <Optional>*mustPunchcardDate;
@property (nonatomic, strong) NSMutableArray <Optional>*noPunchcardDate;
@property (nonatomic, copy) NSString <Optional>*reslutData;
@property (nonatomic, copy) NSString <Optional>*attendanceStartTime;
@property (nonatomic, copy) NSString <Optional>*attendanceAddress;
@property (nonatomic, copy) NSString <Optional>*attendanceWifi;
@property (nonatomic, copy) NSString <Optional>*outwokerStatus;
@property (nonatomic, copy) NSString <Optional>*faceStatus;

@end
