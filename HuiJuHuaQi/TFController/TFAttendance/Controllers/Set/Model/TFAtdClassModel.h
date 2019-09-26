//
//  TFAtdClassModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFAtdClassModel @end

@interface TFAtdClassModel : JSONModel
//    "name":"正常上班",             //班次名称
//    "times":"1",                   //上下班次数
//    "time1Start":1111             //第一次上班开始时间
//    "time1End": 1111              //第一次下班结束时间
//    "time1StartLimit ":"0"           //上班打卡限制
//    "time1EndLimit ": "0"            //下班打卡限制
//    "time1EndStatus ": "0"           //强制状态  0强制 1不强制
//    "rest1Start ":111              //第一次休息开始时间
//    "rest1End ": 1111              //第一次休息结束时间
//    "time2Start ":1111             //第二次上班开始时间
//    "time2End ": "0"                 //第二次下班开始时间
//    "time2StartLimit ":"0"          //上班打卡限制
//    "time2EndLimit ": "0"            //下班打卡限制
//    "time2EndStatus ": "0"                //强制状态  0强制 1不强制
//    "time3Start ":111                   //第二次上班开始时间
//    "time3End ": 111                    //第二次下班开始时间
//    "time3StartLimit ":"0"                //上班打卡限制
//    "time3EndLimit ": "0"                 //下班打卡限制
//    "time3EndStatus ": "0"                //强制状态  0强制 1不强制
//    "totalWorkingHours ": "8小时30分钟"            //总共工作时长
//    "attendanceTime ": 07:00-10.30；11:00-14:30；15:00-19:30  //考勤时间
@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, copy) NSString <Optional>*classDesc;
@property (nonatomic, copy) NSString <Optional>*classType;
@property (nonatomic, copy) NSString <Optional>*time1Start;
@property (nonatomic, copy) NSString <Optional>*time1End;
@property (nonatomic, copy) NSString <Optional>*time1StartLimit;
@property (nonatomic, copy) NSString <Optional>*time1EndLimit;
@property (nonatomic, copy) NSString <Optional>*time1EndStatus;
@property (nonatomic, copy) NSString <Optional>*rest1Start;
@property (nonatomic, copy) NSString <Optional>*rest1End;
@property (nonatomic, copy) NSString <Optional>*time2Start;
@property (nonatomic, copy) NSString <Optional>*time2End;
@property (nonatomic, copy) NSString <Optional>*time2StartLimit;
@property (nonatomic, copy) NSString <Optional>*time2EndLimit;
@property (nonatomic, copy) NSString <Optional>*time2EndStatus;
@property (nonatomic, copy) NSString <Optional>*time3Start;
@property (nonatomic, copy) NSString <Optional>*time3End;
@property (nonatomic, copy) NSString <Optional>*time3StartLimit;
@property (nonatomic, copy) NSString <Optional>*time3EndLimit;
@property (nonatomic, copy) NSString <Optional>*time3EndStatus;
@property (nonatomic, copy) NSString <Optional>*totalWorkingHours;
@property (nonatomic, copy) NSString <Optional>*attendanceTime; //提交
@property (nonatomic, copy) NSString <Optional>*attendance_time; //获取
@property (nonatomic, copy) NSString <Optional>*time; // 记录时间
@property (nonatomic, strong) NSNumber <Optional>*effectiveDate; // 生效

@property (nonatomic, strong) NSNumber <Ignore>*isSelect;

@end
