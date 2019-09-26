//
//  TFEmailSendModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailAttachmentsModel.h"

@interface TFEmailSendModel : JSONModel

//{
//    "subject":"邮件测试",                    //邮箱主题
//    "account_id": 1,                         //发件人邮件ID
//    "from_recipient": "163@163.com",                    //发件人账号
//    "mail_content": "凤凰山",                    //邮件内容
//    "to_recipients": [{
//        "employee_name":"张三",
//        "mail_account":"126@126.com "
//    }
//                      …
//                      ]，            //收件人 多人用,分隔
//    "cc_recipients":[{
//        "employee_name":"张三",
//        "mail_account":"126@126.com "
//    }
//                     …
//                     ]，             //抄送人
//    "bcc_recipients":[{
//        "employee_name":"张三",
//        "mail_account":"126@126.com "
//    }
//                      …
//                      ]，                       //密送人
//    "cc_setting": 0,                          //是否选择抄送人 0 否 1 是
//    "bcc_setting": 0，                        //是否选择密送人 0 否 1 是
//    "single_show": 0，                      //是否群发单显，0 否 1 是
//    "is_emergent":0,                      //是否为紧急邮件  0否 1 是
//    "is_notification": 0,                  //是否需要回执 0 否 1 是
//    "is_plain": 0,                      //是否为纯文本  0 否 1 是
//    "is_track": 1，                      // 是否追踪 0 否1 是
//    "is_encryption": 0,                   //是否加密 0 否 1 是
//    "is_signature": 0,                   //是否签名 0 否 1 是
//    "signature_id": 0,                   //签名ID
//    "mail_source": 0,                    //邮件来源 0 PC 1 手机
//    "attachments_name":[{
//        "fileName":"123.jpg",
//        "fileType":"jpg",
//        "fileSize":"123456",
//        "fileUrl":"http://123/123.jpg"
//        
//        
//    }]      //附件名多邮件以逗号分隔
//    
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*subject;

@property (nonatomic, strong) NSNumber <Optional>*account_id;

@property (nonatomic, copy) NSString <Optional>*from_recipient;

@property (nonatomic, copy) NSString <Optional>*mail_content;

@property (nonatomic, strong) NSArray <Optional>*to_recipients;

@property (nonatomic, strong) NSArray <Optional>*cc_recipients;

@property (nonatomic, strong) NSArray <Optional>*bcc_recipients;

@property (nonatomic, strong) NSNumber <Optional>*cc_setting;

@property (nonatomic, strong) NSNumber <Optional>*bcc_setting;

@property (nonatomic, strong) NSNumber <Optional>*single_show;

@property (nonatomic, strong) NSNumber <Optional>*is_emergent;

@property (nonatomic, strong) NSNumber <Optional>*is_notification;

@property (nonatomic, strong) NSNumber <Optional>*is_plain;

@property (nonatomic, strong) NSNumber <Optional>*is_track;

@property (nonatomic, strong) NSNumber <Optional>*is_encryption;

@property (nonatomic, strong) NSNumber <Optional>*is_signature;

@property (nonatomic, strong) NSNumber <Optional>*signature_id;

@property (nonatomic, strong) NSNumber <Optional>*mail_source;

@property (nonatomic, strong) NSArray <Optional>*attachments_name;

@end
