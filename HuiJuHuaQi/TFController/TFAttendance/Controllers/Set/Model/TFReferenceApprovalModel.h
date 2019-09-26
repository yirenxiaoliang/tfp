//
//  TFReferenceApprovalModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 "id" : 5,
 "relevance_bean" : "bean1548490639024",
 "create_by" : 18,
 "chinese_name" : "请假",
 "duration_field" : "number_1548490651108",
 "start_time_field" : "datetime_create_time",
 "del_status" : "0",
 "modify_by" : "",
 "duration_unit" : "1",
 "end_time_field" : "datetime_modify_time",
 "create_time" : 1551671670358,
 "modify_time" : "",
 "relevance_status" : "1"
 */
@interface TFReferenceApprovalModel : JSONModel


@property (nonatomic, strong) NSNumber <Optional>*id;
/** 关联bean */
@property (nonatomic, copy) NSString <Optional>*relevance_bean;
/** 审批单名 */
@property (nonatomic, copy) NSString <Optional>*relevance_title;
/** 对应时长 */
@property (nonatomic, copy) NSString <Optional>*duration_field;
/** 对应时长名称 */
@property (nonatomic, copy) NSString <Optional>*duration_name;
/** 开始字段 */
@property (nonatomic, copy) NSString <Optional>*start_time_field;
/** 开始字段名称 */
@property (nonatomic, copy) NSString <Optional>*start_time_name;
/** 结束字段 */
@property (nonatomic, copy) NSString <Optional>*end_time_field;
/** 开始字段名称 */
@property (nonatomic, copy) NSString <Optional>*end_time_name;
/** 修正状态：0：缺卡 1：请假 2： 加班 3：出差 4：销假 5： 外出 */
@property (nonatomic, copy) NSString <Optional>*relevance_status;
/** 时长单位 */
@property (nonatomic, copy) NSString <Optional>*duration_unit;

/** 自定义模块图标颜色 */
@property (nonatomic, copy) NSString <Optional>*icon_color;
/** 自定义模块图标类型 */
@property (nonatomic, copy) NSString <Optional>*icon_type;
/** 自定义模块图标URL */
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** 自定义模块ID */
@property (nonatomic, strong) NSNumber <Optional>*relevance_id;

@end

NS_ASSUME_NONNULL_END
