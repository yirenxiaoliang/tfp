//
//  NSObject+HQNull.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "NSObject+HQNull.h"

@implementation NSObject (HQNull)

- (id)nullProcess
{
    if(self == [NSNull null])
    {
        return nil;
    }else if ([self isEqual:@"(null)"]) { //服务端会返回这样的情况
        return nil;
    }else{
        return self;
    }
}

@end
