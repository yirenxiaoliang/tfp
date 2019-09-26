//
//  TFAtdWatDataListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdLocationModel.h"

@protocol TFAtdWatDataListModel @end

@interface TFAtdWatDataListModel : JSONModel


//{
//    "create_by": 1,
//    "effective_range": "300",  //有效范围
//    "address": "广东省深圳市南山区科技园科技园高新南一道16号", //考勤地址
//    "create_time": 1529654981779,
//    "modify_time": 1529660082239,
//    "name": "联想公司", //考勤名称
//    "location": [
//                 {
//                     "address": "广东省深圳市南山区科技园科技园高新南一道16号",
//                     "lng": 113.9477,
//                     "lat": 22.539118
//                 }
//                 ],
//    "del_status": "0",
//    "id": 24,
//    "modify_by": 1,
//    "attendance_status": "0", //开启状态 0开启  1禁用
//    "attendance_type": "0"
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*address;

@property (nonatomic, strong) NSArray <TFAtdLocationModel,Optional>*location;

@property (nonatomic, copy) NSString <Optional>*effective_range;

@property (nonatomic, copy) NSString <Optional>*attendance_status;

@property (nonatomic, strong) NSNumber <Optional>*create_by;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*modify_time;

@property (nonatomic, copy) NSString <Optional>*del_status;

@property (nonatomic, strong) NSNumber <Optional>*modify_by;

@property (nonatomic, copy) NSString <Optional>*attendance_type;

@property (nonatomic, strong) NSNumber <Ignore>*select;

@end
