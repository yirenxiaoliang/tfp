//
//  TFProjectRowModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmployModel.h"
#import "TFCustomerOptionModel.h"
#import "TFFieldNameModel.h"
#import "TFProjectLabelModel.h"
#import "TFCustomRowModel.h"
#import "TFEmailPersonModel.h"
#import "TFFileModel.h"

@protocol TFProjectRowModel

@end


@interface TFProjectRowModel : JSONModel


/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*projectId;

/** 项目分组id */
@property (nonatomic, strong) NSNumber <Optional>*sectionId;

/** 项目分组任务列名称 */
@property (nonatomic, copy) NSString <Optional>*name;

/** hidden:隐藏 */
@property (nonatomic, copy) NSString <Ignore>*hidden;

/** 项目分组任务列名称s */
@property (nonatomic, strong) NSMutableArray <Ignore>*names;

/** 排序 */
@property (nonatomic, strong) NSNumber <Optional>*sort;

/** 项目分组id */
@property (nonatomic, strong) NSNumber <Optional>*main_id;

/** timeId */
@property (nonatomic, strong) NSNumber <Optional>*timeId;

/** flowId */
@property (nonatomic, strong) NSNumber <Ignore>*flowId;
/** flowStatus */
@property (nonatomic, strong) NSNumber <Ignore>*flowStatus;

/** ---------------字段-------------- */
/** 紧急状态 */
@property (nonatomic, strong) NSNumber <Optional>*urgeType;
/** 完成状态 */
@property (nonatomic, strong) NSNumber <Optional>*finishType;
/** 任务名称 */
@property (nonatomic, copy) NSString <Optional>*taskName;
/** 激活次数 */
@property (nonatomic, strong) NSNumber <Optional>*activeNum;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startTime;
/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*endTime;
/** 子任务个数 */
@property (nonatomic, strong) NSNumber <Optional>*childTaskNum;
/** 完成子任务个数 */
@property (nonatomic, strong) NSNumber <Optional>*finishChildTaskNum;
/** 负责人 */
@property (nonatomic, strong) TFEmployModel <Optional>*responsibler;
/** 标签s */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel>*tagList;

/** 是否为引用数据 */
@property (nonatomic, strong) NSNumber <Optional>*quote_status;
/** 状态s */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel>*picklist_status;
/** 优先级 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel>*picklist_priority;


/** *********************************公用********************************* */

/** 子任务 */
@property (nonatomic, strong) NSNumber<Optional> *from;
/** 公用id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
@property (nonatomic, strong) NSNumber<Optional> *dataType;
/** taskInfoId */
//@property (nonatomic, strong) NSNumber <Optional>*taskInfoId;
/** quoteTaskId */
//@property (nonatomic, strong) NSNumber <Optional>*quoteTaskId;
/** quoteTaskId */
@property (nonatomic, strong) NSNumber <Optional>*associatesTaskInfoId;

/** completeStatus */
@property (nonatomic, strong) NSNumber <Optional>*complete_status;
/** completeStatus */
@property (nonatomic, strong) NSNumber <Optional>*complete_number;



/** 备忘录 */
/** 提醒时间 */
@property (nonatomic, strong) NSNumber<Optional> *remind_time;
/** 备忘录标题 */
@property (nonatomic, copy) NSString <Optional>*title;
/** 创建时间 */
@property (nonatomic, strong) NSNumber<Optional> *create_time;
/** 共享人id */
@property (nonatomic, copy) NSString <Optional>*share_ids;
/** 创建人id */
@property (nonatomic, strong) NSNumber<Optional> *create_by;
/** 创建人 */
@property (nonatomic, strong) TFEmployModel<Optional> *createObj;


/** 任务
 "checkStatus" : "1",
 "picklist_tag" : "",
 "personnel_create_by" : "2",
 */
/** taskDict 任务自定义，某些字段没有写死 */
@property (nonatomic, strong) NSDictionary <Ignore>*taskDict;
/** passed_status */
@property (nonatomic, copy) NSString <Optional>*passed_status;
/** check_status */
@property (nonatomic, copy) NSString <Optional>*check_status;
/** 执行人 */
@property (nonatomic, strong) NSArray <Optional,TFEmployModel>*personnel_principal;
//@property (nonatomic, copy) NSString <Optional>*personnel_execution;
/** text_name */
@property (nonatomic, copy) NSString <Optional>*text_name;
/** activate_number */
@property (nonatomic, strong) NSNumber<Optional> *activate_number;
/** datetime_deadline */
@property (nonatomic, strong) NSNumber<Optional> *datetime_deadline;
/** datetime_starttime */
@property (nonatomic, strong) NSNumber<Optional> *datetime_starttime;
/** datetime_create_time */
@property (nonatomic, strong) NSNumber<Optional> *datetime_create_time;
/** picklist_tag */
@property (nonatomic, strong) NSArray<Optional,TFProjectLabelModel> *picklist_tag;
/** picklist_tag */
@property (nonatomic, copy) NSString<Optional> *participants_only;
/** task_type */
@property (nonatomic, copy) NSString <Optional>*task_type;

/** 自定义*/
/** 执行人 */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel>*row;

/** rows */
@property (nonatomic, strong) TFCustomRowModel <Optional>*rows;
/** beanId */
//@property (nonatomic, strong) NSNumber <Optional>*beanId;
///** beanName */
//@property (nonatomic, copy) NSString <Optional>*beanName;
/** beanId */
@property (nonatomic, strong) NSNumber <Optional>*bean_id;
/** beanName */
@property (nonatomic, copy) NSString <Optional>*bean_name;
/** quote_id */
@property (nonatomic, strong) NSNumber <Optional>*quote_id;
/** bean_type:1备忘录、2项目任务、3自定义、4审批、5个人任务 */
@property (nonatomic, strong) NSNumber <Optional>*bean_type;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_color;
/** icon_type */
@property (nonatomic, strong) NSNumber <Optional>*icon_type;
/** icon_url */
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** module_id */
@property (nonatomic, strong) NSNumber <Optional>*module_id;
/** module_name */
@property (nonatomic, copy) NSString <Optional>*module_name;


/** 审批 */
/** task_id */
@property (nonatomic, strong) NSNumber <Optional>*task_id;
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

/** 邮件 */

//主题
@property (nonatomic, copy) NSString <Optional>*subject;
//发件人
@property (nonatomic, copy) NSString <Optional>*from_recipient;

/** 选择 */
@property (nonatomic, strong) NSNumber <Ignore>*select;


//邮件内容
@property (nonatomic, copy) NSString <Optional>*mail_content;

// 2 审批通过 3 审批驳回 4 已撤销 10 没有审批
@property (nonatomic, copy) NSString <Optional>*approval_status;

@property (nonatomic, copy) NSString <Optional>*mail_source;

@property (nonatomic, copy) NSString <Optional>*embedded_images;

//0 未读 1 已读
@property (nonatomic, copy) NSString <Optional>*read_status;

@property (nonatomic, copy) NSString <Optional>*is_track;

@property (nonatomic, copy) NSString <Optional>*bcc_setting;

//附件
@property (nonatomic, strong) NSMutableArray <TFFileModel,Optional>*attachments_name;

//收件人
@property (nonatomic, strong) NSMutableArray <TFEmailPersonModel,Optional>*to_recipients;

//抄送人
@property (nonatomic, strong) NSMutableArray <TFEmailPersonModel,Optional>*cc_recipients;

@property (nonatomic, strong) NSMutableArray <TFEmailPersonModel,Optional>*bcc_recipients;

//0 非紧急 1 紧急
@property (nonatomic, copy) NSString <Optional>*is_emergent;

@property (nonatomic, copy) NSString <Optional>*is_plain;

@property (nonatomic, strong) NSNumber <Optional>*mail_box_id;

// 0 未发送  1 已发送 2 部分发送
@property (nonatomic, strong) NSNumber <Optional>*send_status;

@property (nonatomic, copy) NSString <Optional>*is_notification;

//发件人姓名
@property (nonatomic, copy) NSString <Optional>*from_recipient_name;

//0 不是定时发送 1 定时发送
@property (nonatomic, copy) NSString <Optional>*timer_status;

//定时时间
@property (nonatomic, strong) NSNumber <Optional>*timer_task_time;

//0 不是草稿 1 是草稿
@property (nonatomic, strong) NSNumber <Optional>*draft_status;

//邮件标签
@property (nonatomic, copy) NSString <Optional>*mail_tags;

@property (nonatomic, strong) NSNumber <Optional>*signature_id;

@property (nonatomic, strong) NSNumber <Optional>*account_id;

@property (nonatomic, copy) NSString <Optional>*single_show;

@property (nonatomic, copy) NSString <Optional>*is_signature;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, copy) NSString <Optional>*is_encryption;

@property (nonatomic, copy) NSString <Optional>*cc_setting;

@property (nonatomic, copy) NSString <Optional>*personnel_approverBy;

@property (nonatomic, copy) NSString <Optional>*personnel_ccTo;

@property (nonatomic, copy) NSString <Optional>*ip_address;

@property (nonatomic, strong) NSNumber <Optional>*process_instance_id;

@property (nonatomic, strong) NSNumber <Ignore>*isHide;

/** 0:新增 1:回复 2:转发 */
@property (nonatomic, strong) NSNumber <Ignore>*type;


@property (nonatomic, strong) NSNumber <Ignore>*showFile;

@property (nonatomic, strong) NSNumber <Ignore>*cellHeight;

@end
