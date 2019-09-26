//
//  TFRelevanceFieldModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRelevanceFieldModel.h"

@implementation TFRelevanceFieldModel


-(id)copyWithZone:(NSZone *)zone{
    
    TFRelevanceFieldModel *model = [[TFRelevanceFieldModel alloc] init];
    model.fieldId = self.fieldId;
    model.fieldName = self.fieldName;
    model.fieldLabel = self.fieldLabel;
    model.operatorType = self.operatorType;
    model.value = self.value;
    
    return model;
}


-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFRelevanceFieldModel *model = [[TFRelevanceFieldModel alloc] init];
    model.fieldId = self.fieldId;
    model.fieldName = self.fieldName;
    model.fieldLabel = self.fieldLabel;
    model.operatorType = self.operatorType;
    model.value = self.value;
    
    
    return model;
}

@end
