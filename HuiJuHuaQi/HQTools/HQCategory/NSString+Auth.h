//
//  NSString+Auth.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Auth)

/** 是否有功能权限 */
-(BOOL)isFunctionAuthWithFunctionId:(NSInteger)functionId;
/** 是否具有特殊功能权限 */
-(BOOL)isSpecialFunctionAuthWithFunctionId:(NSInteger)functionId;
/** 自己是否具有操作某人某功能的权限 */
-(BOOL)isFunctionAuthWithFunctionId:(NSInteger)functionId peopleId:(NSNumber *)peopleId;



@end
