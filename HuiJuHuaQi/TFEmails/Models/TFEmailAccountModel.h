//
//  TFEmailAccountModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFEmailAccountModel : JSONModel

//{
//    "id" : 1,
//    "status" : "0",
//    "receive_server_port" : 45,
//    "send_server" : "smtp.126.com",
//    "starttls_transport_secure" : "1",
//    "receive_server" : "pop3.126.com",
//    "receive_server_type" : "POP3",
//    "receive_server_secure" : "0",
//    "send_server_port" : 263,
//    "sending_sychronize" : "0",
//    "password" : "chenyul1991",
//    "employee_id" : 1,
//    "sended_sychronize" : "0",
//    "account_default" : "0",
//    "create_time" : 1520320757191,
//    "nickname" : "陈宇亮",
//    "send_server_secure" : "0",
//    "account" : "chenyul1991@126.com"
//}

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*status;

@property (nonatomic, strong) NSNumber <Optional>*receive_server_port;

@property (nonatomic, strong) NSNumber <Optional>*send_server;

@property (nonatomic, strong) NSNumber <Optional>*starttls_transport_secure;

@property (nonatomic, strong) NSNumber <Optional>*receive_server;

@property (nonatomic, strong) NSNumber <Optional>*receive_server_type;

@property (nonatomic, strong) NSNumber <Optional>*receive_server_secure;

@property (nonatomic, strong) NSNumber <Optional>*send_server_port;

@property (nonatomic, strong) NSNumber <Optional>*sending_sychronize;

@property (nonatomic, copy) NSString <Optional>*password;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, strong) NSNumber <Optional>*sended_sychronize;

/** 默认账号 */
@property (nonatomic, copy) NSString <Optional>*account_default;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, copy) NSString <Optional>*nickname;

@property (nonatomic, strong) NSNumber <Optional>*send_server_secure;

@property (nonatomic, copy) NSString <Optional>*account;

/** 0:未勾选 1:勾选 */
@property (nonatomic, strong) NSNumber <Ignore>*isSelect;

@end
