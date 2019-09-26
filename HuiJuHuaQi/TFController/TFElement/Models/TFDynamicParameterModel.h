//
//  TFDynamicParameterModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFDynamicParameterModel <NSObject>

@end

@interface TFDynamicParameterModel : JSONModel

/**
 "id": -1,
 "identifer": "personnel_create_by",
 "value": "3-personnel_create_by",
 "name": "创建人"
 */

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 标识 */
@property (nonatomic, copy) NSString <Optional>*identifer;
/** value */
@property (nonatomic, copy) NSString <Optional>*value;
/** 名称 */
@property (nonatomic, copy) NSString <Optional>*name;
/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;
/** roles */
@property (nonatomic, strong) NSArray <TFDynamicParameterModel,Optional>*roles;

/** level */
@property (nonatomic, strong) NSNumber <Ignore>*level;

@property (nonatomic, strong) NSNumber <Optional>*type;


@end

NS_ASSUME_NONNULL_END
