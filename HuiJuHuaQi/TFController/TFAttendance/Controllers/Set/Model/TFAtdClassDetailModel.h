//
//  TFAtdClassDetailModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAtdClassDetailModel : JSONModel

//{
//    "create_by": 8,
//    "classes_id": 100,
//    "create_time": 1533269508767,
//    "serial": "三班倒",
//    "current_month": 1533052800000,
//    "employee_id": "1",
//    "del_status": "0",
//    "id": 7483,
//    "work_time": 1533225600000,
//    "schedule_id": 88
//}

@property (nonatomic ,strong) NSNumber <Optional>*create_by;
@property (nonatomic ,strong) NSNumber <Optional>*classes_id;
@property (nonatomic ,strong) NSNumber <Optional>*create_time;
@property (nonatomic ,copy) NSString <Optional>*serial;
@property (nonatomic ,strong) NSNumber <Optional>*current_month;
@property (nonatomic ,strong) NSNumber <Optional>*employee_id;
@property (nonatomic ,copy) NSString <Optional>*del_status;
@property (nonatomic ,strong) NSNumber <Optional>*id;
@property (nonatomic ,strong) NSNumber <Optional>*work_time;
@property (nonatomic ,strong) NSNumber <Optional>*schedule_id;

@end
