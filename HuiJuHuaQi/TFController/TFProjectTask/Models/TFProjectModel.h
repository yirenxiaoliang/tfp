//
//  TFProjectModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"


@protocol TFProjectModel

@end

@interface TFProjectModel : JSONModel

/**"star_time" : "",
 "temp_type" : "",
 "name" : "在线等急",
 "id" : 9,
 "note" : "在于他用过",
 "leader" : 1,
 "temp_status" : "0",
 "create_by" : 1,
 "del_status" : "0",
 "modify_by" : "",
 "pic_url" : "",
 "temp_id" : 0,
 "visual_range_status" : "0",
 "end_time" : 1524974100000,
 "star_level" : "",
 "create_time" : 1524628579540,
 "modify_time" : "",
 "sort" : ""
 */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** note */
@property (nonatomic, copy) NSString <Optional>*note;
/** visualRange */
@property (nonatomic, strong) NSNumber <Optional>*visual_range_status;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*leader;
/** leader_pic */
@property (nonatomic, copy) NSString <Optional>*leader_pic;
/** pic_url */
@property (nonatomic, copy) NSString <Optional>*pic_url;
/** system_default_pic */
@property (nonatomic, copy) NSString <Optional>*system_default_pic;
/** leader_name */
@property (nonatomic, copy) NSString <Optional>*leader_name;
/** endTime */
@property (nonatomic, strong) NSNumber <Optional>*end_time;
/** startTime */
@property (nonatomic, strong) NSNumber <Optional>*start_time;
/** startTime */
@property (nonatomic, strong) NSNumber <Optional>*create_time;
/** tempId */
@property (nonatomic, strong) NSNumber <Optional>*temp_id;
/** star_level */
@property (nonatomic, strong) NSNumber <Optional>*star_level;
/** project_status   （0进行中（启用） 1归档 2暂停 3删除 ）*/
@property (nonatomic, copy) NSString <Optional>*project_status;
/** project_progress_status */
@property (nonatomic, strong) NSNumber <Optional>*project_progress_status;
/** project_progress_content */
@property (nonatomic, strong) NSNumber <Optional>*project_progress_content;
/** deadline_status */
@property (nonatomic, copy) NSString <Optional>*deadline_status;
/** task_complete_count */
@property (nonatomic, strong) NSNumber <Optional>*task_complete_count;
/** task_count */
@property (nonatomic, strong) NSNumber <Optional>*task_count;
/** project_progress_number */
@property (nonatomic, strong) NSNumber <Optional>*project_progress_number;

/** 激活是否需要填写激活原因 */
@property (nonatomic, copy) NSString <Optional>*project_complete_status;
/** 修改截止时间是否需要填写修改原因 */
@property (nonatomic, copy) NSString <Optional>*project_time_status;

/** selectState */
@property (nonatomic, strong) NSNumber <Ignore>*selectState;

/** 已完成 */
@property (nonatomic, strong) NSNumber <Optional>*complete_number;

/** 进行中 */
@property (nonatomic, strong) NSNumber <Optional>*doing_number;

/** 超期未开始 */
@property (nonatomic, strong) NSNumber <Optional>*overdue_no_begin_number;

/** 未开始 */
@property (nonatomic, strong) NSNumber <Optional>*no_begin_number;
/** 已暂停 */
@property (nonatomic, strong) NSNumber <Optional>*stop_number;



@end
