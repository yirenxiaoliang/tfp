//
//  TFTFEmailAddessBookItemModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol  TFEmailAddessBookItemModel @end

@interface TFEmailAddessBookItemModel : JSONModel

    //                     "create_time": 1520327647593,
    //                     "employee_id": 1,
    //                     "name": "陈宇亮",
    //                     "del_status": "0",
    //                     "id": 3,
    //                     "mail_address": "chenyul1991@qq.com"
    //                 },

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, strong) NSNumber <Optional>*del_status;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*mail_address;

@property (nonatomic, copy) NSString <Optional>*mail_account;

@property (nonatomic, strong) NSNumber <Ignore>*select;

@property (nonatomic, strong) NSNumber <Ignore>*index;

@end
