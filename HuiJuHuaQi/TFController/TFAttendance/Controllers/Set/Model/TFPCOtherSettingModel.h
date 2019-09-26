//
//  TFPCOtherSettingModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFPCOtherSettingModel : JSONModel

//{
//    "adminArr":1,3,5                        //管理员
//    "remindCockBeforeWork":15,              //上班前打卡提醒
//    " remindClockAfterWork":30,             //下班后打卡提醒
//    "listSetType": 0,                       //榜单统计方式（0分开、1一起）
//    "listSetEarlyArrival": 10               //早到榜统计人数
//    "listSetDiligent": 10                   //勤勉榜统计人数
//    "listSetBeLate": 10                     //迟到榜统计人数
//    "listSetSortType":0,                    //排序方式（0迟到次数、1迟到时长）
//    "lateNigthWalkArr":[],                  //设置晚到晚走数组
//    "humanizationAllowLateTimes":3,         //人性化允许每月迟到次数
//    "humanizationAllowLateMinutes":10,      //人性化允许单次迟到分钟数
//    "absenteeismRuleBeLateMinutes":30,      //单次迟到超过分钟数为旷工
//    "absenteeismRuleLeaveEarlyMinutes ":30  //单次早退分钟数为旷工
//}

@property (nonatomic, strong) NSMutableArray <Optional>*adminArr;
@property (nonatomic, copy) NSString <Optional>*remindCockBeforeWork;
@property (nonatomic, copy) NSString <Optional>*remindClockAfterWork;
@property (nonatomic, copy) NSString <Optional>*listSetType;
@property (nonatomic, copy) NSString <Optional>*listSetEarlyArrival;
@property (nonatomic, copy) NSString <Optional>*listSetDiligent;
@property (nonatomic, copy) NSString <Optional>*listSetBeLate;
@property (nonatomic, copy) NSString <Optional>*listSetSortType;
@property (nonatomic, copy) NSString <Optional>*lateNigthWalkArr;
@property (nonatomic, copy) NSString <Optional>*humanizationAllowLateTimes;
@property (nonatomic, copy) NSString <Optional>*humanizationAllowLateMinutes;
@property (nonatomic, copy) NSString <Optional>*absenteeismRuleBeLateMinutes;
@property (nonatomic, copy) NSString <Optional>*absenteeismRuleLeaveEarlyMinutes;

@end
