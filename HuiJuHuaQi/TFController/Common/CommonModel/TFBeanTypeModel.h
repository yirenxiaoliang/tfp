//
//  TFBeanTypeModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/3.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFNormalPeopleModel.h"

@protocol TFBeanTypeModel 

@end

@interface TFBeanTypeModel : JSONModel
/** {
 "module_bean": "",
 "menu_code": 0,
 "menu_label": "全部客户"
 }, */

/** 模块bean */
@property (nonatomic, copy) NSString <Optional>*module_bean;
/** beanType值 */
@property (nonatomic, strong) NSNumber <Optional>*menu_code;
/** 菜单描述 */
@property (nonatomic, copy) NSString <Optional>*menu_label;
/** 描述 */
@property (nonatomic, copy) NSString <Optional>*moduleId;

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 描述 */
@property (nonatomic, copy) NSString <Optional>*name;
/** 是否为公海池管理员 */
@property (nonatomic, copy) NSString <Optional>*is_seas_admin;
/** 是否为公海池 */
@property (nonatomic, copy) NSString <Optional>*is_seas_pool;
/** 菜单类型 */
@property (nonatomic, copy) NSString <Optional>*type;
//@property (nonatomic, copy) NSString <Optional>*query_parameter;
@property (nonatomic, copy) NSString <Optional>*query_condition;
/** 是否为公海池管理员 */
//@property (nonatomic, copy) NSArray <Optional,TFNormalPeopleModel>*allot_manager;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;

@end
