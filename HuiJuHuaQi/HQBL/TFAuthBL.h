//
//  TFAuthBL.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseBL.h"

@interface TFAuthBL : HQBaseBL

/**  获取员工角色(当前登录人)
 *
 *
 */
- (void)requestGetEmployeeRole;

/**  查询角色拥有的权限
 *
 * @param roleId 角色id
 *
 */
- (void)requestGetRoleAuthWithRoleId:(NSString *)roleId;



/**  查询员工模块权限(当前登录人)
 *
 */
- (void)requestGetEmployeeModelAuth;

/**  查询模块的功能权限
 *
 * @param moduleId 模块id--1：市场活动 2：客户 3：报价 4：订单 5：合同 6：回款 7：发票 8：商品 9：投诉建议
 */
- (void)requestGetEmployeeModelAuthWithModuleId:(NSNumber *)moduleId;

@end
