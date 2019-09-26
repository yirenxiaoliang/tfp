//
//  TFQuoteTaskItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFQuoteTaskItemModel

@end

@interface TFQuoteTaskItemModel : JSONModel

/**
 "sub_id" : 334,
 "end_time" : 0,
 "employee_name" : "尹明亮",
 "bean_name" : "project_custom_51",
 "id" : 426,
 "relation_id" : "",
 "project_id" : 51,
 "module_name" : "任务",
 "module_id" : "",
 "task_name" : "手机新建任务"
 */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** sub_id */
@property (nonatomic, strong) NSNumber <Optional>*sub_id;
/** project_id */
@property (nonatomic, strong) NSNumber <Optional>*project_id;
/** end_time */
@property (nonatomic, strong) NSNumber <Optional>*end_time;
/** employee_name */
@property (nonatomic, copy) NSString <Optional>*employee_name;
/** bean_name */
@property (nonatomic, copy) NSString <Optional>*bean_name;
/** relation_id */
@property (nonatomic, copy) NSString <Optional>*relation_id;
/** module_name */
@property (nonatomic, copy) NSString <Optional>*module_name;
/** module_id */
@property (nonatomic, copy) NSString <Optional>*module_id;
/** task_name */
@property (nonatomic, copy) NSString <Optional>*task_name;


/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;



@end
