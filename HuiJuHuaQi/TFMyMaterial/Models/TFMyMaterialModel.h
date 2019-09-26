//
//  TFMyMaterialModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFMyMaterialModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, strong) NSNumber <Optional>*sex;

@property (nonatomic, copy) NSString <Optional>*department;

@property (nonatomic, copy) NSString <Optional>*sign;

@property (nonatomic, copy) NSString <Optional>*photo;

@property (nonatomic, strong) NSNumber <Optional>*fabulous_count;

@property (nonatomic, strong) NSNumber <Optional>*fabulous_status;

@end
