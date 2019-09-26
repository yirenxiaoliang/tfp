//
//  TFCustomerOptionModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFFieldNameModel.h"

@protocol TFCustomerOptionModel
@end

@interface TFCustomerOptionModel : JSONModel<NSCopying,NSMutableCopying>

/**
 "value": "0",
 "label": "深圳"
 */

/** 选项index */
@property (nonatomic, copy) NSString <Optional>*value;

/** 选项值 */
@property (nonatomic, copy) NSString <Optional>*label;

/** 选项颜色 */
@property (nonatomic, copy) NSString <Optional>*color;


/** 选项依赖 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel> *relyonList;

/** 隐藏的字段 */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel> *hidenFields;

/** 控制字段 */
@property (nonatomic, copy) NSString <Optional>*controlField;


/** 默认值 */
@property (nonatomic, copy) NSString <Optional>*defaultValue;
/** 默认值id */
@property (nonatomic, copy) NSString <Optional>*defaultValueId;
/** 默认值颜色 */
@property (nonatomic, copy) NSString <Optional>*defaultValueColor;

/** 二级选项 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel> *subList;



/** 父级ID */
@property (nonatomic, strong) NSNumber <Ignore>*parentId;

/** 选中 */
@property (nonatomic, strong) NSNumber <Ignore>*open;
/** 隐藏 */
@property (nonatomic, strong) NSNumber <Ignore>*hidden;

@end
