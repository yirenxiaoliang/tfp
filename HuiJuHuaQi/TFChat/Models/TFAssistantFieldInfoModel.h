//
//  TFAssistantFieldInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerFieldModel.h"

@protocol TFAssistantFieldInfoModel @end

@interface TFAssistantFieldInfoModel : JSONModel

//{
//    "field_value" : "装甲部队",
//    "id" : 2,
//    "type" : "text",
//    "field_label" : "名称"
//},

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*field_value;

@property (nonatomic, copy) NSString <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*field_label;

@property (nonatomic, strong) TFCustomerFieldModel <Optional> *field;

@end
