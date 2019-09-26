//
//  TFApprovalListItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFApprovalListItemModel



@end

@interface TFApprovalListItemModel : JSONModel

/**
 "del_status" : 0,
 "process_name" : "请假1",
 "module_data_id" : 1,
 "process_status" : 0,
 "begin_user_name" : "尹明亮",
 "id" : 1,
 "begin_user_id" : 5,
 "create_time" : 1515396750161,
 "process_definition_id" : "process1515392483043:1:2504",
 "process_key" : "process1515392483043",
 "module_bean" : "bean1515381477326"
 */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** email_id */
@property (nonatomic, strong) NSNumber <Optional>*email_id;
/** task_id */
@property (nonatomic, copy) NSString <Optional>*task_id;
/** task_key */
@property (nonatomic, copy) NSString <Optional>*task_key;
/** task_name */
@property (nonatomic, copy) NSString <Optional>*task_name;
/** module_data_id */
@property (nonatomic, copy) NSString <Optional>*approval_data_id;
/** module_bean */
@property (nonatomic, copy) NSString <Optional>*module_bean;
/** begin_user_name */
@property (nonatomic, copy) NSString <Optional>*begin_user_name;
/** begin_user_id */
@property (nonatomic, strong) NSNumber <Optional>*begin_user_id;
/** create_time */
@property (nonatomic, strong) NSNumber <Optional>*create_time;
/** process_definition_id */
@property (nonatomic, copy) NSString <Optional>*process_definition_id;
/** process_key */
@property (nonatomic, copy) NSString <Optional>*process_key;
/** process_name */
@property (nonatomic, copy) NSString <Optional>*process_name;
/** process_status */
@property (nonatomic, strong) NSNumber <Optional>*process_status;
/** del_status */
@property (nonatomic, strong) NSNumber <Optional>*del_status;
/** read_status */
@property (nonatomic, copy) NSString <Optional>*status;
/** process_field_v */
@property (nonatomic, strong) NSNumber <Optional>*process_field_v;
/** picture */
@property (nonatomic, copy) NSString <Optional>*picture;

/** 小助手列表字段 */
@property (nonatomic, copy) NSString <Optional>*fromType;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;



@end
