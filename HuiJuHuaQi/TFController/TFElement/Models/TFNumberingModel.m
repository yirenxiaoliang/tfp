//
//  TFNumberingModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNumberingModel.h"

@implementation TFNumberingModel

-(id)copyWithZone:(NSZone *)zone{
    
    TFNumberingModel *model = [[TFNumberingModel alloc] init];
    
//    model.fixedValue = self.fixedValue;
    model.dateValue = self.dateValue;
    model.serialValue = self.serialValue;
    
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFNumberingModel *model = [[TFNumberingModel alloc] init];
    
//    model.fixedValue = self.fixedValue;
    model.dateValue = self.dateValue;
    model.serialValue = self.serialValue;
    
    return model;
}

@end
