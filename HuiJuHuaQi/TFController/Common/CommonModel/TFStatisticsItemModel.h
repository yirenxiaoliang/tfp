//
//  TFStatisticsItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFStatisticsItemModel

@end

@interface TFStatisticsItemModel : JSONModel
/**
 
 "modify_by_id" = 15;
 "report_name" = "report_1524555667138";
 
 
 */


/** 标题 */
@property (nonatomic, copy) NSString <Optional>*report_label;
/** report_name */
@property (nonatomic, copy) NSString <Optional>*report_name;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*create_time;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*create_by_id;
/** 创建人 */
@property (nonatomic, copy) NSString <Optional>*create_by_name;
/** 数据来源bean */
@property (nonatomic, copy) NSString <Optional>*data_source_name;
/** 数据来源title */
@property (nonatomic, copy) NSString <Optional>*data_source_label;
/** //报表类型：0列表式、1汇总式、2矩阵式 */
@property (nonatomic, strong) NSNumber <Optional>*report_type;
/** 数据id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** modify_by_id */
@property (nonatomic, strong) NSNumber <Optional>*modify_by_id;
/** 数据来源title */
@property (nonatomic, copy) NSString <Optional>*name;


@end
