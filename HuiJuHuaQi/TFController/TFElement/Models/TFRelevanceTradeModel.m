//
//  TFRelevanceTradeModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRelevanceTradeModel.h"

@implementation TFRelevanceTradeModel

-(id)copyWithZone:(NSZone *)zone{
    
    TFRelevanceTradeModel *model = [[TFRelevanceTradeModel alloc] init];
    
    model.moduleName = self.moduleName;
    model.moduleLabel = self.moduleLabel;
    
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFRelevanceTradeModel *model = [[TFRelevanceTradeModel alloc] init];
    
    model.moduleName = self.moduleName;
    model.moduleLabel = self.moduleLabel;
    
    return model;
    
}

@end
