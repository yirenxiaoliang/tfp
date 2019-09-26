//
//  TFProjectPeopleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFProjectPeopleModel : JSONModel


/** project_id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** project_id */
@property (nonatomic, strong) NSNumber <Optional>*project_id;
/** employee_id */
@property (nonatomic, strong) NSNumber <Optional>*employee_id;
/** employee_pic */
@property (nonatomic, copy) NSString <Optional>*employee_pic;
/** post_name */
@property (nonatomic, copy) NSString <Optional>*post_name;
/** employee_name */
@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*project_role;
@property (nonatomic, copy) NSString <Optional>*project_role_name;
/** project_role 项目角色 0负责人 1执行人2协作人3访客4外部 */
/** project_task_role 项目任务角色 0负责人 1执行人2协作人3访客4外部 */
@property (nonatomic, copy) NSString <Optional>*project_task_role;
@property (nonatomic, copy) NSString <Optional>*project_task_status;
/** project_member_id */
@property (nonatomic, strong) NSNumber <Optional>*project_member_id;
/** project_member_id */
@property (nonatomic, strong) NSNumber <Optional>*task_id;
/** selectState */
@property (nonatomic, strong) NSNumber <Ignore>*selectState;



@end
