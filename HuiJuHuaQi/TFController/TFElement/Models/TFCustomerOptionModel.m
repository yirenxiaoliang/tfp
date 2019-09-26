//
//  TFCustomerOptionModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerOptionModel.h"

@implementation TFCustomerOptionModel


-(id)copyWithZone:(NSZone *)zone{
    
    TFCustomerOptionModel *model = [[TFCustomerOptionModel alloc] init];
    
    model.label = self.label;
    model.value = self.value;
    model.color = self.color;
    model.defaultValue = self.defaultValue;
    model.defaultValueId = self.defaultValueId;
    model.defaultValueColor = self.defaultValueColor;
    
    NSMutableArray<Optional,TFCustomerOptionModel> *subList = [NSMutableArray<Optional,TFCustomerOptionModel> array];
    for (TFCustomerOptionModel *option in self.subList) {
        [subList addObject:[option copy]];
    }
    model.subList = subList;
    
    
    
    return model;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFCustomerOptionModel *model = [[TFCustomerOptionModel alloc] init];
    
    model.label = self.label;
    model.value = self.value;
    model.color = self.color;
    model.defaultValue = self.defaultValue;
    model.defaultValueId = self.defaultValueId;
    model.defaultValueColor = self.defaultValueColor;
    
    NSMutableArray<Optional,TFCustomerOptionModel> *subList = [NSMutableArray<Optional,TFCustomerOptionModel> array];
    for (TFCustomerOptionModel *option in self.subList) {
        [subList addObject:[option copy]];
    }
    model.subList = subList;
    
    
    
    return model;
    
}
@end
