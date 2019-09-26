//
//  TFPCSettingDetailMocel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"


@protocol TFLateNigthWalk @end
@interface TFLateNigthWalk : JSONModel
@property (nonatomic, copy) NSString <Optional>*lateMin;
@property (nonatomic, copy) NSString <Optional>*nigthwalkmin;

@end

@interface TFPCSettingDetailMocel : JSONModel

//{
//    "id":"1",                               //记录ID
//    " admin_arr ":1,3,5                        //管理员
//    " remind_clock_before_work ":15,              //上班前打卡提醒
//    " remind_clock_after_work ":30,             //下班后打卡提醒
//    " list_set_type ": 0,                       //榜单统计方式（0分开、1一起）
//    " list_set_early_arrival ": 10               //早到榜统计人数
//    " list_set_diligent ": 10                   //勤勉榜统计人数
//    " list_set_be_late ": 10                     //迟到榜统计人数
//    " list_set_sort_type ":0,                    //排序方式（0迟到次数、1迟到时长）
//    " late_nigth_walk_arr ":[],                  //设置晚到晚走数组
//    " humanization_allow_late_times ":3,         //人性化允许每月迟到次数
//    " humanization_allow_late_minutes ":10,      //人性化允许单次迟到分钟数
//    " absenteeism_rule_be_late_minutes ":30,      //单次迟到超过分钟数为旷工
//    " absenteeism_rule_leave_early_minutes ":30  //单次早退分钟数为旷工

//"create_time": 1532662371328,
//"modify_time": 1532664811124,
//"del_status": "0",
//"modify_by": 1,
//"create_by": 1,
//}

@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, copy) NSArray <HQEmployModel,Optional>*admin_arr;
@property (nonatomic, strong) NSNumber <Optional>*remind_clock_before_work;
@property (nonatomic, strong) NSNumber <Optional>*remind_clock_after_work;
@property (nonatomic, copy) NSString <Optional>*list_set_type;
@property (nonatomic, copy) NSString <Optional>*list_set_early_arrival;
@property (nonatomic, copy) NSString <Optional>*list_set_diligent;
@property (nonatomic, copy) NSString <Optional>*list_set_be_late;
@property (nonatomic, copy) NSString <Optional>*list_set_sort_type;
@property (nonatomic, strong) NSArray <TFLateNigthWalk,Optional>*late_nigth_walk_arr;
@property (nonatomic, copy) NSString <Optional>*humanization_allow_late_times;
@property (nonatomic, copy) NSString <Optional>*humanization_allow_late_minutes;
@property (nonatomic, copy) NSString <Optional>*absenteeism_rule_be_late_minutes;
@property (nonatomic, copy) NSString <Optional>*absenteeism_rule_leave_early_minutes;

@property (nonatomic, strong) NSNumber <Optional>*create_time;
@property (nonatomic, strong) NSNumber <Optional>*modify_time;
@property (nonatomic, copy) NSString <Optional>*del_status;
@property (nonatomic, strong) NSNumber <Optional>*modify_by;
@property (nonatomic, strong) NSNumber <Optional>*create_by;

@end
