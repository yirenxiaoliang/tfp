//
//  TFEmailReceiveListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailPersonModel.h"
#import "TFEmailAttachmentsModel.h"

@protocol TFEmailReceiveListModel @end

@interface TFEmailReceiveListModel : JSONModel

//{
//    “mail_content”: “测试邮件可以不回复”,
//    “from_recipient”: “18688783645@126.com”,
//    "from_recipient_name": "张三",                    //发件人姓名
//    “subject”: “邮件测试”,
//    “approval_status”: “0”,   // 0 审批未通过 1 已通过 2待审批
//    “send_status”: “0”,   // 0 未发送  1 已发送 2 部分发送
//    “bcc_recipients”: “”,
//    “mail_source”: “0”,
//    “embedded_images”: “”,
//    “read_status”: “0”,       //0 未读 1 已读
//    “timer_status”: “0”,            //0 不是定时发送 1 定时发送
//    “draft_status”: “0”,            //0 不是草稿 1 是草稿
//    “mail_tags”:“标签1，标签2”,            //邮件标签
//    “is_track”: “1”,
//    “bcc_setting”: “0”,
//    “attachments_name”: [],
//    “to_recipients”: [
//                      {
//                          “mail_account”: “dengshunli12345678@qq.com”,
//                          “employee_name”: “张三”
//                      }
//                      ],
//    “cc_recipients”: “”,
//    “is_emergent”: “0”,   //0 非紧急 1 紧急
//    “signature_id”: 0,
//    “account_id”: 5,
//    “single_show”: “0”,
//    “is_plain”: “0”,
//    “is_signature”: “0”,
//    “employee_id”: 1,
//    “is_encryption”: “0”,
//    “is_notification”: “0”,
//    “id”: 87,
//    “cc_setting”: “0”
//},timer_task_time

//邮件内容
@property (nonatomic, copy) NSString <Optional>*mail_content;
@property (nonatomic, copy) NSString <Ignore>*contentSimple;

//发件人
@property (nonatomic, copy) NSString <Optional>*from_recipient;

@property (nonatomic, copy) NSString <Optional>*create_time;

//主题
@property (nonatomic, copy) NSString <Optional>*subject;

// 2 审批通过 3 审批驳回 4 已撤销 10 没有审批
@property (nonatomic, copy) NSString <Optional>*approval_status;

@property (nonatomic, strong) NSNumber <Optional>*mail_source;

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

@property (nonatomic, strong) NSNumber <Optional>*is_plain;

@property (nonatomic, strong) NSNumber <Optional>*mail_box_id;

// 0 未发送  1 已发送 2 部分发送
@property (nonatomic, strong) NSNumber <Optional>*send_status;

@property (nonatomic, copy) NSString <Optional>*is_notification;

@property (nonatomic, strong) NSNumber <Optional>*id;

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

@property (nonatomic, strong) NSNumber <Ignore>*select;

@end
