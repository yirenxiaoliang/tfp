//
//  HQBaseEntity.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/12.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseEntity.h"
#import <objc/runtime.h>

@implementation HQBaseEntity

+ (id)entity
{
    HQBaseEntity *entity = [[[self class] alloc] init];
    return entity;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self encodeProperties:coder];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        [self decodeProperties:decoder];
    }
    return self;
}

- (void)decodeProperties:(NSCoder *)decoder
{
    unsigned int outCount = 0;
    unsigned int i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = [decoder decodeObjectForKey:propertyName];
        if (propertyValue) {
            [self setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

- (void)encodeProperties:(NSCoder *)coder
{
    unsigned int outCount = 0;
    unsigned int i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:propertyName];
        
        [coder encodeObject:propertyValue forKey:propertyName];
    }
    free(properties);
}

- (NSString *)description
{
    unsigned int outCount = 0;
    unsigned int i = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableString *str = [[NSMutableString alloc] init];
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [str appendString:propertyName];
        [str appendString:@":"];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue==nil) {
            [str appendString:@"nil"];
        }else{
            [str appendString:[propertyValue description]];
        }
        [str appendString:@","];
    }
    free(properties);
    return str;
}

- (id)copy
{
    Class instanceClass = [self class];
    id instance = [[instanceClass alloc]init];
    unsigned int propertyCount = 0;
    
    objc_property_t * properties = class_copyPropertyList(instanceClass, &propertyCount);
    for (int i = 0 ; i < propertyCount; i ++) {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id propertyValue = [self valueForKey:propertyName];
        
        id newProperty = [propertyValue copy];
        
        [instance setValue:newProperty forKey:propertyName];
    }
    free(properties);
    return instance;
}

- (void)dealloc
{
}


@end
