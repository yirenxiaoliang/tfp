//
//  NSObject+Equel.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "NSObject+Equel.h"

@implementation NSObject (Equel)

- (BOOL)isEqualToString:(NSString *)aString{
    
    HQLog(@"我是NSObject+Equel.h中的isEqualToString：(%@)%@==(%@)%@",NSStringFromClass([self class]),self.description,NSStringFromClass([aString class]),aString.description);
    return [self.description isEqualToString:aString.description];
}

- (BOOL)isEqualToNumber:(NSNumber *)number{
    
    HQLog(@"我是NSObject+Equel.h中的isEqualToNumber：(%@)%@==(%@)%@",NSStringFromClass([self class]),self.description,NSStringFromClass([number class]),number.description);
    return [self.description isEqualToString:number.description];
}
@end
