//
//  TFEmailWebViewHeadModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailPersonModel.h"

@protocol TFEmailWebViewHeadModel @end

@interface TFEmailWebViewHeadModel : JSONModel

//{
//    　　"ip_address":"IP",
//    　　"time":"2017-06-04 15:16（星期一）",
//    　　"subject":"邮件主题",
//        "from_recipient":@"18688783645@126.com",
//        "from_recipient_name": "张三",
//    　　"cc_recipients":[
//                       　　　　{
//                           　　　　　　"employee_name":"收件人名字",
//                           　　　　　　"mail_account":"fdf@fda.com"
//                           　　　　}
//                       　　],
//    　　"bcc_recipients":[
//                        　　　　{
//                            　　　　　　"employee_name":"密送人名字",
//                            　　　　　　"mail_account":"fdf@fda.com"
//                            　　　　}
//                        　　],
//    　　"to_recipients":[
//                       　　　　{
//                           　　　　　　"employee_name":"抄送人名字",
//                           　　　　　　"mail_account":"fdf@fda.com"
//                           　　　　}
//                       　　]
//}

@property (nonatomic, copy) NSString <Optional>*ip_address;

@property (nonatomic, copy) NSString <Optional>*time;

@property (nonatomic, copy) NSString <Optional>*subject;

@property (nonatomic, copy) NSString <Optional>*from_recipient;

@property (nonatomic, copy) NSString <Optional>*from_recipient_name;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*cc_recipients;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*bcc_recipients;

@property (nonatomic, strong) NSArray <TFEmailPersonModel,Optional>*to_recipients;

@end
