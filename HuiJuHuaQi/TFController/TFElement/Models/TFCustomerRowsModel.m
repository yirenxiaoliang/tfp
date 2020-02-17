//
//  TFCustomerRowsModel.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/8/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerRowsModel.h"

@implementation TFCustomerRowsModel


-(id)copyWithZone:(NSZone *)zone{
    
    TFCustomerRowsModel *model = [TFCustomerRowsModel allocWithZone:zone];
    
    model.label = self.label;
    model.name = self.name;
    model.width = self.width;
    model.state = self.state;
    model.remove = self.remove;
    model.type = self.type;
    model.typeText = self.typeText;
    model.relyonFields = self.relyonFields;

    model.field = [self.field copy];
    model.relevanceField = [self.relevanceField copy];
    model.relevanceModule = [self.relevanceModule copy];
    model.numbering = [self.numbering copy];
    model.linkage = self.linkage;
    
    NSMutableArray *relevanceWhere = [NSMutableArray array];
    for (TFRelevanceFieldModel *field in self.relevanceWhere) {
        [relevanceWhere addObject:[field copy]];
    }
    model.relevanceWhere = [NSArray<Optional,TFRelevanceFieldModel> arrayWithArray:relevanceWhere];
    
    
    NSMutableArray *entrys = [NSMutableArray array];
    for (TFCustomerOptionModel *option in self.entrys) {
        [entrys addObject:[option copy]];
    }
    model.entrys = [NSArray<Optional,TFCustomerOptionModel> arrayWithArray:entrys];
    
    NSMutableArray *subforms = [NSMutableArray array];
    for (TFCustomerRowsModel *row in self.componentList) {
        [subforms addObject:[row copy]];
    }
    model.componentList = [NSArray<Optional,TFCustomerRowsModel> arrayWithArray:subforms];
    model.controlFieldHide = self.controlFieldHide;
    model.height = @44;
    return model;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFCustomerRowsModel *model = [TFCustomerRowsModel allocWithZone:zone];
    
    
    model.label = self.label;
    model.name = self.name;
    model.width = self.width;
    model.state = self.state;
    model.remove = self.remove;
    model.type = self.type;
    model.typeText = self.typeText;
    model.relyonFields = self.relyonFields;
    
    model.field = [self.field copy];
    model.relevanceField = [self.relevanceField copy];
    model.relevanceModule = [self.relevanceModule copy];
    model.numbering = [self.numbering copy];
    model.linkage = self.linkage;
    
    NSMutableArray *relevanceWhere = [NSMutableArray array];
    for (TFRelevanceFieldModel *field in self.relevanceWhere) {
        [relevanceWhere addObject:[field copy]];
    }
    model.relevanceWhere = [NSArray<Optional,TFRelevanceFieldModel> arrayWithArray:relevanceWhere];
    
    
    NSMutableArray *entrys = [NSMutableArray array];
    for (TFCustomerOptionModel *option in self.entrys) {
        [entrys addObject:[option copy]];
    }
    model.entrys = [NSArray<Optional,TFCustomerOptionModel> arrayWithArray:entrys];
    
    NSMutableArray *subforms = [NSMutableArray array];
    for (TFCustomerRowsModel *row in self.componentList) {
        [subforms addObject:[row copy]];
    }
    model.componentList = [NSArray<Optional,TFCustomerRowsModel> arrayWithArray:subforms];
    
    
    model.controlFieldHide = self.controlFieldHide;
    model.height = @44;
    
    return model;
}

@end
