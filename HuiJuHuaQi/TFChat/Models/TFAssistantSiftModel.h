//
//  TFAssistantSiftModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAssistantSiftModel : JSONModel

//{
//    "topper" : "",
//    "datetime_modify_time" : "",
//    "del_status" : "0",
//    "id" : 1,
//    "personnel_create_by" : "1",
//    "application_id" : 1,
//    "english_name" : "bean1514602151147",
//    "chinese_name" : "宇亮测试推送模块",
//    "personnel_modify_by" : "",
//    "datetime_create_time" : 1514602138608,
//    "icon" : "el-icon-star-off"
//}

@property (nonatomic, copy) NSString <Optional>*topper;

@property (nonatomic, copy) NSString <Optional>*datetime_modify_time;

@property (nonatomic, copy) NSString <Optional>*del_status;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*personnel_create_by;

@property (nonatomic, strong) NSNumber <Optional>*application_id;

@property (nonatomic, copy) NSString <Optional>*english_name;

@property (nonatomic, copy) NSString <Optional>*chinese_name;

@property (nonatomic, copy) NSString <Optional>*personnel_modify_by;

@property (nonatomic, strong) NSNumber <Optional>*datetime_create_time;

@property (nonatomic, copy) NSString <Optional>*icon;

@end
