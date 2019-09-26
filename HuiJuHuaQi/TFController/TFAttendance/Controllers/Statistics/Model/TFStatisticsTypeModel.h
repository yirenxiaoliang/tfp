//
//  TFStatisticsTypeModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/12.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TFStatisticsTypeModel <NSObject>
@end

@interface TFStatisticsTypeModel : JSONModel

/**
 "number": 0,
 "dataList": [],
 "name": "迟到人数",
 "type": 1
 */
/** 统计数值 */
@property (nonatomic, strong) NSNumber <Optional>*number;
/** 人员 */
@property (nonatomic, strong) NSArray <Optional,TFEmployModel>*employeeList;
/** 人员 */
@property (nonatomic, strong) NSArray <Optional,TFDimensionModel>*attendanceList;

/** 统计维度名称 */
@property (nonatomic, copy) NSString <Optional>*name;
/** 统计维度类型,0：打卡人数，1：迟到，2：早退，3：缺卡,4:旷工，5：外勤打卡，6：关联审批  9:正常打卡 */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** 未打卡人员 */
@property (nonatomic, strong) TFStatisticsTypeModel <Optional>*nopunchClock;

@end

NS_ASSUME_NONNULL_END
