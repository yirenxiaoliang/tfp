//
//  TFEmailDetailModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailPersonModel.h"
#import "TFEmailAttachmentsModel.h"

@interface TFEmailDetailModel : JSONModel

//{
//    "mail_content": "测试邮件可以不回复",
//    "from_recipient": "18688783645@126.com",
//    "create_time": 1520389046953,
//    "subject": "邮件测试",
//    "approval_status": "0",
//    "bcc_recipients": [],
//    "mail_source": "0",
//    "embedded_images": "",
//    "read_status": "0",
//    "is_track": "1",
//    "draft_status": "0",
//    "bcc_setting": "0",
//    "attachments_name": [],
//    "to_recipients": [
//                      {
//                          "mail_account": "dengshunli12345678@qq.com",
//                          "employee_name": "张三"
//                      }
//                      ],
//    "cc_recipients": [],
//    "is_emergent": "0",
//    "is_plain": "0",
//    "timer_status": "0",
//    "send_status": "1",
//    "is_notification": "0",
//    "id": 32,
//    "mail_tags": ""
//"ip_address": "0",                 //发件人IP地址

//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*mail_content;

@property (nonatomic, copy) NSString <Optional>*from_recipient;

@property (nonatomic, copy) NSString <Optional>*from_recipient_name;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, copy) NSString <Optional>*subject;

@property (nonatomic, copy) NSString <Optional>*approval_status;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*bcc_recipients;

@property (nonatomic, copy) NSString <Optional>*mail_source;

@property (nonatomic, copy) NSString <Optional>*embedded_images;

@property (nonatomic, copy) NSString <Optional>*read_status;

@property (nonatomic, copy) NSString <Optional>*is_track;

@property (nonatomic, copy) NSString <Optional>*draft_status;

@property (nonatomic, copy) NSString <Optional>*bcc_setting;

@property (nonatomic, strong) NSArray <TFEmailAttachmentsModel,Optional>*attachments_name;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*to_recipients;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*cc_recipients;

@property (nonatomic, copy) NSString <Optional>*is_emergent;

@property (nonatomic, copy) NSString <Optional>*is_plain;

@property (nonatomic, copy) NSString <Optional>*timer_status;

@property (nonatomic, copy) NSString <Optional>*send_status;

@property (nonatomic, copy) NSString <Optional>*is_notification;

@property (nonatomic, copy) NSString <Optional>*mail_tags;

@property (nonatomic, copy) NSString <Optional>*ip_address;

@property (nonatomic, strong) NSNumber <Ignore>*isHide;

@end
