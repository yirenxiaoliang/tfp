//
//  TFEmployModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"
#import "TFDimensionModel.h"

@protocol TFEmployModel

@end

@interface TFEmployModel : JSONModel

/**  "leader": "0",
 "post_id": "1",
 "phone": "",
 "is_enable": "",
 "role_id": "1",
 "user_name": "员工名称",
 "mobile_phone": "18565656565",
 "id": "7",
 "picture": "",
 "email": "",
 "account": "123346",
 "status": "0"
 }
 */

/** leader */
@property (nonatomic, copy) NSString <Optional>*mobile_phone;
/** leader */
@property (nonatomic, copy) NSString <Optional>*region;
/** leader */
@property (nonatomic, copy) NSString <Optional>*leader;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*post_id;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*role_id;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*sign_id;
/** leader */
@property (nonatomic, copy) NSString <Optional>*post_name;
/** leader */
@property (nonatomic, copy) NSString <Optional>*phone;
/** leader */
@property (nonatomic, copy) NSString <Optional>*is_enable;
/** leader */
@property (nonatomic, copy) NSString <Optional>*employee_name;
/** leader */
@property (nonatomic, copy) NSString <Optional>*name;
//@property (nonatomic, copy) NSString <Optional>*user_name;
/** leader */
@property (nonatomic, copy) NSNumber <Optional>*sex;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** leader */
@property (nonatomic, strong) NSNumber <Optional>*employee_id;
/** leader */
@property (nonatomic, copy) NSString <Optional>*picture;
/** leader */
@property (nonatomic, copy) NSString <Optional>*email;
/** leader */
@property (nonatomic, copy) NSString <Optional>*account;
/** leader */
@property (nonatomic, copy) NSString <Optional>*sign;
/** leader */
@property (nonatomic, copy) NSString <Optional>*status;
/** 部门id */
@property (nonatomic, strong) NSNumber <Optional>*departmentId;
/** 部门名 */
@property (nonatomic, copy) NSString <Optional>*departmentName;
/** 企业圈背景图 */
@property (nonatomic, copy) NSString <Optional>*microblog_background;
/** birth */
@property (nonatomic, strong) NSNumber <Optional>*birth;
/** value */
@property (nonatomic, copy) NSString <Optional>*value;

/** 职位 */
@property (nonatomic, copy) NSString <Optional>*duty_name;

/** 员工层级 */
@property (nonatomic, strong) NSNumber <Ignore>*level;
/** 员工选中 0:未选中 1:选中 2:固定选中(不可选) */
@property (nonatomic, strong) NSNumber <Ignore>*select;

/** 心情 */
@property (nonatomic, copy) NSString <Optional>*mood;

/** 状态 */
@property (nonatomic, strong) NSArray<Optional> *statusList;
/** 维度数据 */
@property (nonatomic, strong) NSArray<TFDimensionModel,Optional> *attendanceList;

//-(HQEmployModel *)employee;

@end
