//
//  TFEmailModuleAccountModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailModuleItemModel.h"

@interface TFEmailModuleAccountModel : JSONModel

@property (nonatomic, strong) NSArray <TFEmailModuleItemModel,Optional>*email_fields;

@property (nonatomic, strong) TFEmailModuleItemModel <Optional>*first_field;

@end
