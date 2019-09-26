//
//  TFCustomAuthModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFCustomAuthModel

@end

@interface TFCustomAuthModel : JSONModel
/**
 "func_id" : 1,
 "func_name" : "新增\/导入",
 "bean_name" : "bean1513767079635",
 "id" : 1,
 "role_id" : 3,
 "auth_code" : 1,
 "module_id" : 1,
 "data_auth" : 2 */

/** func_id */
@property (nonatomic, strong) NSNumber <Optional>*func_id;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** role_id */
@property (nonatomic, strong) NSNumber <Optional>*role_id;
/** auth_code */
@property (nonatomic, strong) NSNumber <Optional>*auth_code;
/** module_id */
@property (nonatomic, strong) NSNumber <Optional>*module_id;
/** data_auth */
@property (nonatomic, strong) NSNumber <Optional>*data_auth;
/** func_name */
@property (nonatomic, copy) NSString <Optional>*func_name;
/** bean_name */
@property (nonatomic, copy) NSString <Optional>*bean_name;

@end
