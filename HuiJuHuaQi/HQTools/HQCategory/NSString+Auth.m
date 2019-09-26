//
//  NSString+Auth.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "NSString+Auth.h"

@implementation NSString (Auth)


/** 是否有功能权限 */
-(BOOL)isFunctionAuthWithFunctionId:(NSInteger)functionId{
    
    
    if ([self containsString:[NSString stringWithFormat:@"\"auth_code\":%ld",functionId]]) {// 有功能
        
        return YES;
      
    }else{
        
        return NO;
    }

}

/** 是否具有特殊功能权限 */
-(BOOL)isSpecialFunctionAuthWithFunctionId:(NSInteger)functionId{
    
    
    if ([self containsString:[NSString stringWithFormat:@"\"auth_code\":%ld,\"func_type\":1",functionId]]) {// 有特殊功能
        return YES;
        
    }else{
        
        return NO;
    }
    
}

/** 自己是否具有操作某人某功能的权限 */
-(BOOL)isFunctionAuthWithFunctionId:(NSInteger)functionId peopleId:(NSNumber *)peopleId{
    
    if ([self isFunctionAuthWithFunctionId:functionId]) {// 有功能
        
        if ([HQHelper isMyselfWithEmployeeId:peopleId]) {// 自己
            
            return YES;
            
        }else{
            
            if ([self isSpecialFunctionAuthWithFunctionId:functionId]) {// 有特殊功能
                
                return YES;
            }else{
                return NO;
            }
            
        }
    }else{
        return NO;
    }
    
}


@end
