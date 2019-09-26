//
//  TFParameterModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFParameterModel <NSObject>

@end

@interface TFParameterModel : JSONModel

/**
 "id":-1,
 "name":"负责人",
 "type":3,
 "value":"3-personnel_principal",
 "identifer":"personnel_principal"
 
 "picture":"",
 "sign_id":10000,
 "department_id":1
 */


@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, strong) NSNumber <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*value;
@property (nonatomic, copy) NSString <Optional>*identifer;
@property (nonatomic, copy) NSString <Optional>*picture;
@property (nonatomic, strong) NSNumber <Optional>*sign_id;
@property (nonatomic, strong) NSNumber <Optional>*department_id;

@end

NS_ASSUME_NONNULL_END
