//
//  TFCustomerFieldModel.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerFieldModel.h"

@implementation TFCustomerFieldModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"delete": @"adelete"
    }];
}

-(id)copyWithZone:(NSZone *)zone{
    
    TFCustomerFieldModel *model = [[TFCustomerFieldModel alloc] init];
    
    model.detailView = self.detailView;
    model.addView = self.addView;
    model.editView = self.editView;
    model.isOptionHidden = self.isOptionHidden;
    model.optionHiddenName = self.optionHiddenName;
    model.fieldControl = self.fieldControl;
    model.structure = self.structure;
    model.defaultValue = self.defaultValue;
    model.allowScan = self.allowScan;
    // 数组
    model.defaultEntrys = [self.defaultEntrys copy];
    model.defaultValueId = self.defaultValueId;
    model.defaultValueColor = self.defaultValueColor;
    model.pointOut = self.pointOut;
    model.terminalPc = self.terminalPc;
    model.terminalApp = self.terminalApp;
    model.repeatCheck = self.repeatCheck;
    model.formatType = self.formatType;
    model.selectType = self.selectType;
    model.codeType = self.codeType;
    model.codeStyle = self.codeStyle;
    model.commonlyArea = self.commonlyArea;
    model.areaType = self.areaType;
    model.numberDelimiter = self.numberDelimiter;
    // 数组
    model.defaultPersonnel = [self.defaultPersonnel copy];
    model.defaultDepartment = [self.defaultDepartment copy];
    
    model.maxCount = self.maxCount;
    model.countLimit = self.countLimit;
    model.imageSize = self.imageSize;
    model.maxSize = self.maxSize;
    model.phoneLenth = self.phoneLenth;
    model.phoneType = self.phoneType;
    model.numberType = self.numberType;
    model.numberLenth = self.numberLenth;
    model.betweenMin = self.betweenMin;
    model.betweenMax = self.betweenMax;
    model.formula = self.formula;
    model.formulaCalculates = self.formulaCalculates;
    model.decimalLen = self.decimalLen;
    // 数组
    model.choosePersonnel = [self.choosePersonnel copy];
    
    model.chooseType = self.chooseType;
    // 数组
    model.chooseRange = [self.chooseRange copy];
    model.numberDelimiter = self.numberDelimiter;
    model.editorShowDefault = self.editorShowDefault;
    
    
    model.add = self.add;
    model.adelete = self.adelete;
    model.mustFill = self.mustFill;
    return model;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    TFCustomerFieldModel *model = [[TFCustomerFieldModel alloc] init];
    
    model.detailView = self.detailView;
    model.addView = self.addView;
    model.editView = self.editView;
    model.isOptionHidden = self.isOptionHidden;
    model.optionHiddenName = self.optionHiddenName;
    model.fieldControl = self.fieldControl;
    model.structure = self.structure;
    model.defaultValue = self.defaultValue;
    model.allowScan = self.allowScan;
    // 数组
    model.defaultEntrys = [self.defaultEntrys copy];
    model.defaultValueId = self.defaultValueId;
    model.defaultValueColor = self.defaultValueColor;
    model.pointOut = self.pointOut;
    model.terminalPc = self.terminalPc;
    model.terminalApp = self.terminalApp;
    model.repeatCheck = self.repeatCheck;
    model.formatType = self.formatType;
    model.selectType = self.selectType;
    model.codeType = self.codeType;
    model.codeStyle = self.codeStyle;
    model.commonlyArea = self.commonlyArea;
    model.areaType = self.areaType;
    model.numberDelimiter = self.numberDelimiter;
    // 数组
    model.defaultPersonnel = [self.defaultPersonnel copy];
    model.defaultDepartment = [self.defaultDepartment copy];
    
    model.maxCount = self.maxCount;
    model.countLimit = self.countLimit;
    model.imageSize = self.imageSize;
    model.maxSize = self.maxSize;
    model.phoneLenth = self.phoneLenth;
    model.phoneType = self.phoneType;
    model.numberType = self.numberType;
    model.numberLenth = self.numberLenth;
    model.betweenMin = self.betweenMin;
    model.betweenMax = self.betweenMax;
    model.formula = self.formula;
    model.formulaCalculates = self.formulaCalculates;
    model.decimalLen = self.decimalLen;
    // 数组
    model.choosePersonnel = [self.choosePersonnel copy];
    
    model.chooseType = self.chooseType;
    // 数组
    model.chooseRange = [self.chooseRange copy];
    model.numberDelimiter = self.numberDelimiter;
    model.editorShowDefault = self.editorShowDefault;
    
    model.add = self.add;
    model.adelete = self.adelete;
    model.mustFill = self.mustFill;
    return model;
    
}


@end
