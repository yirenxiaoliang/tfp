//
//  TFDimensionModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFDimensionModel <NSObject>
@end

@interface TFDimensionModel : JSONModel
/**
 "real_punchcard_time": 1552352460000,
 "expect_punchcard_time": 1552352400000
 */

/* 迟到时间 */
@property (nonatomic, strong) NSNumber <Optional>*late_time_number;
/* 早退时间 */
@property (nonatomic, strong) NSNumber <Optional>*leave_early_time_number;

@property (nonatomic, strong) NSNumber <Optional>*real_punchcard_time;

@property (nonatomic, strong) NSNumber <Optional>*expect_punchcard_time;

@property (nonatomic, copy) NSString <Optional>*punchcard_address;
@property (nonatomic, copy) NSString <Optional>*punchcardAddress;

@property (nonatomic, copy) NSString <Optional>*punchcard_type;
@property (nonatomic, copy) NSString <Optional>*punchcardType;

/** 期望日期 */
@property (nonatomic, strong) NSNumber <Optional>*attendanceDate;
/** 期望日期 */
@property (nonatomic, strong) NSNumber <Optional>*attendance_date;
/** 实际打卡时间 */
@property (nonatomic, strong) NSNumber <Optional>*punchcardTime;
@property (nonatomic, copy) NSString <Optional>*duration;

/** 关联审批 */
@property (nonatomic, strong) NSNumber <Optional>*data_id;
@property (nonatomic, copy) NSString <Optional>*chinese_name;
@property (nonatomic, strong) NSNumber <Optional>*employee_id;
@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*bean_name;
@property (nonatomic, copy) NSString <Optional>*start_time;
@property (nonatomic, copy) NSString <Optional>*end_time;
@property (nonatomic, copy) NSString <Optional>*startTime;
@property (nonatomic, copy) NSString <Optional>*endTime;

@property (nonatomic, copy) NSString <Ignore>*mark;

@end

NS_ASSUME_NONNULL_END
