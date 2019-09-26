//
//  TFNoteCreaterModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFNoteCreaterModel @end

@interface TFNoteCreaterModel : JSONModel

//"createObj": {
//    "leader": "0",
//    "mood": "",
//    "is_enable": "1",
//    "personnel_create_by": "",
//    "sex": "",
//    "sign": "",
//    "birth": "",
//    "employee_name": "敕勒歌",
//    "del_status": "0",
//    "remark": "",
//    "role_group_id": 1,
//    "picture": "",
//    "microblog_background": "",
//    "datetime_create_time": "",
//    "post_id": 1,
//    "phone": "13751041565",
//    "role_id": 1,
//    "mobile_phone": "",
//    "name": "企业所有者",
//    "id": 1,
//    "region": "",
//    "email": "",
//    "account": "",
//    "status": "0"
//},

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*datetime_create_time;

@end
