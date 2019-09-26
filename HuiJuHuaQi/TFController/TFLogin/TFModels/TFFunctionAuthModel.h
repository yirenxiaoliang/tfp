//
//  TFFunctionAuthModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFFunctionAuthModel : JSONModel

/** {
 "module_id": "1",
 "func_id": 1,
 "func_type": 0,
 "id": 493
 }
 */

/** 模块id */
@property (nonatomic, copy) NSString <Optional>*module_id;
/** 功能id */
@property (nonatomic, copy) NSString <Optional>*func_id;
/** 功能类型 */
@property (nonatomic, copy) NSString <Optional>*func_type;
/** 功能名称 */
@property (nonatomic, copy) NSString <Optional>*func_name;
/** 数据权限id */
@property (nonatomic, copy) NSString <Optional>*auth_id;


@end
