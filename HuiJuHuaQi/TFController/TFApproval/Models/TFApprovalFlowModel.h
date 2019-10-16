//
//  TFApprovalFlowModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFApprovalFlowModel : JSONModel

/**
 "task_name":"开始流程",
 "next_task_key":"task1",
 "approval_message":"提交审批",
 "task_status_id":"-1",
 "approval_employee_name":"曹建华（员工）",
 "process_definition_id":"caojianhua:1:195004",
 "next_task_name":"多级部门审批",
 "next_approval_employee_name":"李萌（研发主管）",
 "task_status_name":"已提交",
 "next_approval_employee_id":"5",
 "task_key":"startEvent",
 "approval_time":1514964514053,
 "id":14,
 "approval_employee_id":"1" */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** task_key */
@property (nonatomic, copy) NSString <Optional>*task_key;
/** task_name */
@property (nonatomic, copy) NSString <Optional>*task_name;
/** approval_message */
@property (nonatomic, copy) NSString <Optional>*approval_message;
/** approval_time */
@property (nonatomic, strong) NSNumber <Optional>*approval_time;
/** task_approval_type  1会签  2或签 3从角色中指定审批人 */
@property (nonatomic, copy) NSString <Optional>*task_approval_type;
/** task_status_name */
@property (nonatomic, copy) NSString <Optional>*task_status_name;
/** task_status_id // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交 */
@property (nonatomic, copy) NSString <Optional>*task_status_id;
/** approval_employee_name */
@property (nonatomic, copy) NSString <Optional>*approval_employee_name;
/** approval_employee_id */
@property (nonatomic, copy) NSString <Optional>*approval_employee_id;
/** approval_employee_picture */
@property (nonatomic, copy) NSString <Optional>*approval_employee_picture;
/** approval_employee_post */
@property (nonatomic, copy) NSString <Optional>*approval_employee_post;

/** process_definition_id */
@property (nonatomic, copy) NSString <Optional>*process_definition_id;
/** next_task_key */
@property (nonatomic, copy) NSString <Optional>*next_task_key;
/** next_task_name */
@property (nonatomic, copy) NSString <Optional>*next_task_name;
/** next_approval_employee_name */
@property (nonatomic, copy) NSString <Optional>*next_approval_employee_name;
/** next_approval_employee_id */
@property (nonatomic, copy) NSString <Optional>*next_approval_employee_id;
/** process_type */
@property (nonatomic, strong) NSNumber <Optional>*process_type;
/** normal */
@property (nonatomic, strong) NSNumber <Optional>*normal;
/** 签名 */
@property (nonatomic, strong) NSArray <Ignore,TFFileModel>*approval_signature;

/** 上个颜色 0:灰色 1：绿色 2：红色 3:虚线 4:黄色 */
@property (nonatomic, assign) NSNumber <Ignore>*previousColor;

/** 自身颜色 0:灰色 1：绿色 2：红色 3:虚线 4:黄色  */
@property (nonatomic, assign) NSNumber <Ignore>*selfColor;


/** 是否隐藏节点 */
@property (nonatomic, strong) NSNumber <Ignore>*dot;

@end
