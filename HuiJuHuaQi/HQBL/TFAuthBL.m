//
//  TFAuthBL.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAuthBL.h"

@implementation TFAuthBL


/**  获取员工角色(当前登录人)
 *
 *
 */
- (void)requestGetEmployeeRole{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_getEmployeeRole];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getEmployeeRole
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
    
}


/**  查询角色拥有的权限
 *
 * @param roleId 角色id
 *
 */
- (void)requestGetRoleAuthWithRoleId:(NSString *)roleId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    if (roleId) {
        [dic setObject:roleId forKey:@"roleId"];
    }
    
    
    NSString *url = [super urlFromCmd:HQCMD_getRoleAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getRoleAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}


/**  查询员工模块权限(当前登录人)
 *
 */
- (void)requestGetEmployeeModelAuth{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *url = [super urlFromCmd:HQCMD_getEmployeeModuleAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getEmployeeModuleAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

/**  查询模块的功能权限
 *
 * @param moduleId 模块id--1：市场活动 2：客户 3：公海池 4：联系人 5：报价 6：订单 7：合同 8：回款 9：发票 10：商品 11：投诉建议
 */
- (void)requestGetEmployeeModelAuthWithModuleId:(NSNumber *)moduleId{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (moduleId) {
        [dic setObject:moduleId forKey:@"moduleId"];
    }
    
    NSString *url = [super urlFromCmd:HQCMD_getModuleFunctionAuth];
    
    HQRequestItem *requestItem = [RM requestToURL:url
                                           method:@"GET"
                                     requestParam:dic
                                            cmdId:HQCMD_getModuleFunctionAuth
                                         delegate:self
                                       startBlock:^(HQCMD cmd, NSInteger sid) {
                                       }];
    
    [self.tasks addObject:requestItem];
}

#pragma mark - Response
- (void)requestManager:(HQRequestManager *)manager sequenceID:(NSInteger)sid didCompleteWithData:(id)data cmdId:(HQCMD)cmdId{
    BOOL result = [super requestManager:manager commonData:data sequenceID:sid cmdId:cmdId];
    HQResponseEntity *resp = nil;
    
    if (result) {
        
        switch (cmdId) {
            case HQCMD_getEmployeeRole:
            {
                NSString *str = [HQHelper dictionaryToJson:data];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
            }
                break;
            case HQCMD_getRoleAuth:
            {
                NSString *str = [HQHelper dictionaryToJson:data];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
            }
                break;
            case HQCMD_getEmployeeModuleAuth:
            {
                NSString *str = [HQHelper dictionaryToJson:data];
                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
            }
                break;
            case HQCMD_getModuleFunctionAuth:
            {
//                NSArray *arr = data[kData];
//                NSMutableArray *datas = [NSMutableArray array];
//                for (NSDictionary *dict in arr) {
//                    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//                    [dataDict setObject:dict[@"id"] forKey:@"id"];
//                    [dataDict setObject:dict[@"func_id"] forKey:@"func_id"];
//                    [dataDict setObject:dict[@"auth_code"] forKey:@"auth_code"];
//                    [dataDict setObject:dict[@"func_type"] forKey:@"func_type"];
//                    [dataDict setObject:dict[@"func_name"] forKey:@"func_name"];
//                    [dataDict setObject:dict[@"role_id"] forKey:@"role_id"];
//                    [dataDict setObject:dict[@"module_id"] forKey:@"module_id"];
//                    [dataDict setObject:dict[@"data_auth"] forKey:@"data_auth"];
//
//                    [datas addObject:dataDict];
//                }
//                NSString *str = [HQHelper dictionaryToJson:datas];
//                str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:str];
                
                NSString *keyStr = @"";
                NSArray *arr = data[kData];
                for (NSDictionary *dict in arr) {
                    NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [di removeObjectForKey:@"auth_code"];
                    [di removeObjectForKey:@"func_type"];
                    keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[self keyValueStringAppendingWithKey:@"auth_code" value:[dict[@"auth_code"] description]]]];
                    keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[self keyValueStringAppendingWithKey:@"func_type" value:[dict[@"func_type"] description]]]];
                    
                    for (NSString *key in [di allKeys]) {
                        
                        keyStr = [keyStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[self keyValueStringAppendingWithKey:key value:[dict[key] description]]]];
                        
                    }
                }
                resp = [HQResponseEntity responseFromCmdId:cmdId sid:sid body:keyStr];
                
            }
                break;
                
            default:
                break;
        }
        
        [super succeedCallbackWithResponse:resp];
    }
    
}

-(NSString *)keyValueStringAppendingWithKey:(NSString *)key value:(NSString *)value{
    
    return [NSString stringWithFormat:@"\"%@\":%@",key,value];
    
}

@end
