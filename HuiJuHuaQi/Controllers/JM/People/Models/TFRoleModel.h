//
//  TFRoleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@protocol TFRoleModel  @end

@interface TFRoleModel : HQBaseVoModel

/** 角色名 */
@property (nonatomic, copy) NSString <Optional>*name;

/** sys_group */
@property (nonatomic, strong) NSNumber <Optional>*sys_group;

/** status */
@property (nonatomic, copy) NSString <Optional>*status;

/** remark */
@property (nonatomic, copy) NSString <Optional>*remark;

/** role_group_id */
@property (nonatomic, strong) NSNumber <Optional>*role_group_id;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;
/** 部门层级 */
@property (nonatomic, strong) NSNumber <Ignore>*level;

/** roles */
@property (nonatomic, strong) NSArray <TFRoleModel,Optional>*roles;

/** value */
@property (nonatomic, copy) NSString <Optional>*value;
/** type */
@property (nonatomic, strong) NSNumber <Optional>*type;

@end
