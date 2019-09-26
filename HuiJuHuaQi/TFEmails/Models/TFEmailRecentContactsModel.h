//
//  TFRecentContactsModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFEmailRecentContactsModel : JSONModel

//{
//    "create_time": 1520333518258,
//    "employee_id": 1,
//    "mail_account": "chenyul1991@qq.com",
//    "employee_name": "陈宇亮",
//    "id": 19
//},

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, copy) NSString <Optional>*mail_account;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Ignore>*select;

@property (nonatomic, strong) NSNumber <Optional>*index;

@end
