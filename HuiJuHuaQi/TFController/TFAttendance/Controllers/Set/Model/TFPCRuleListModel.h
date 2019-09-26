//
//  TFPCRuleListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdClassModel.h"

@protocol TFPCRuleListModel <NSObject>

@end

@interface TFPCRuleListModel : JSONModel

//{
//    "name": "考勤组1-1",
//    "id": 19,
//    "attendance_time": "星期一,星期二,星期三,星期四  班3-2:07:00-14:00;12:00-15:00;16:00-18:00;星期五  班3-2:07:00-14:00;12:00-15:00;16:00-18:00;;星期六,星期日  休息",
//    "attendance_number": 0,
//    "attendance_type": "0"
//},

@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*attendance_time;
@property (nonatomic, strong) NSNumber <Optional>*memeber_number;
@property (nonatomic, strong) NSNumber <Optional>*attendance_type;

@property (nonatomic, strong) NSMutableArray <HQEmployModel,Optional>*excluded_users;
@property (nonatomic, strong) NSMutableArray <HQEmployModel,Optional>*attendance_users;
@property (nonatomic, strong) NSArray <Optional>*work_day_list;

@property (nonatomic, strong) NSArray <TFAtdClassModel,Optional>*selected_class;

@property (nonatomic, strong) NSDictionary<Ignore> *dict;

@end
