//
//  TFEmailModuleItemModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmailModuleItemModel @end

@interface TFEmailModuleItemModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*label;

@property (nonatomic, copy) NSString <Optional>*value;

@end
