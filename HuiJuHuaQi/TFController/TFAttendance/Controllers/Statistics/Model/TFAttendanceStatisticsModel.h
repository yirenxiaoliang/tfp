//
//  TFAttendanceStatisticsModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/12.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFStatisticsTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAttendanceStatisticsModel : JSONModel
/** 统计维度列表 */
@property (nonatomic, strong) NSArray <TFStatisticsTypeModel,Optional>*dataList;
/** 参与考勤人员数量 */
@property (nonatomic, strong) NSNumber<Optional> *attendancePersonNumber;
/** 参与考勤人员数量 */
@property (nonatomic, strong) NSNumber<Optional> *attendance_person_number;
/** 考勤人 */
@property (nonatomic, strong) TFEmployModel <Optional>*employeeInfo;

@end

NS_ASSUME_NONNULL_END
