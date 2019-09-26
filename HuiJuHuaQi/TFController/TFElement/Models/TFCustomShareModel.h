//
//  TFCustomShareModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"

@interface TFCustomShareModel : JSONModel

/**
 "id" : 5,
 "datetime_modify_time" : "",
 "datetime_create_time" : 1514198409433,
 "module_id" : "19",
 "allot_employee" : [
 {
 "sign_id" : 32,
 "id" : 4,
 "picture" : "",
 "type" : 1,
 "text" : "徐晓鹏"
 }
 ],
 "del_status" : "0",
 "employee_id" : 2,
 "personnel_modify_by" : "",
 "bean_name" : "bean1513937622761",
 "allot_employee_v" : "1-4",
 "personnel_create_by" : "2",
 "access_permissions" : "0",
 "target_lable" : "徐晓鹏" */


/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 人员 */
@property (nonatomic, strong) NSMutableArray <Optional>*peoples;
/** 访问权限 0:只读 1：读、写 2：读、写、删 */
@property (nonatomic, strong) NSNumber <Optional>*auth;
/** 是否保存 */
@property (nonatomic, strong) NSNumber <Ignore>*save;


@end
