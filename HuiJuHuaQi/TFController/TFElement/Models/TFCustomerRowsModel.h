//
//  TFCustomerRowsModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/8/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerFieldModel.h"
#import "TFCustomerOptionModel.h"
#import "TFRelevanceFieldModel.h"
#import "TFRelevanceTradeModel.h"
#import "TFNumberingModel.h"
#import "TFMultiOptionalDefaultModel.h"
#import "TFSubformRelationModel.h"

@protocol TFCustomerRowsModel
@end

@interface TFCustomerRowsModel : JSONModel <NSCopying,NSMutableCopying>


/** 字段中文名称 */
@property (nonatomic, copy) NSString <Optional>*label;

/** 字段英文名称 */
@property (nonatomic, copy) NSString <Optional>*name;

/** 组件宽度 */
@property (nonatomic, copy) NSString <Optional>*width;

/** 组件启禁用 */
@property (nonatomic, copy) NSString <Optional>*state;

/** 可移除组件 */
@property (nonatomic, copy) NSString <Optional>*remove;

/** 组件类型 */
@property (nonatomic, copy) NSString <Optional>*type;

/** 组件类型描述 */
@property (nonatomic, copy) NSString <Optional>*typeText;

/** 某公海池隐藏 */
@property (nonatomic, copy) NSString <Optional>*highSeasPool;
/** 是否保密 */
@property (nonatomic, copy) NSString <Ignore>*secret;

/** 字段类型 */
@property (nonatomic, strong) TFCustomerFieldModel <Optional>*field;


/** 关联字段 */
@property (nonatomic, strong) TFRelevanceFieldModel <Optional>*relevanceField;

/** 关联业务 */
@property (nonatomic, strong) TFRelevanceTradeModel <Optional>*relevanceModule;

/** 子表选项关联 */
@property (nonatomic, strong) TFSubformRelationModel <Optional>*subformRelation;
/** 关联关联组件的依赖字段 */
@property (nonatomic, copy) NSString <Optional>*relyonFields;


/** 编号规则 */
@property (nonatomic, strong) TFNumberingModel <Optional>*numbering;

/** 关联字段表 */
@property (nonatomic, strong) NSArray <Optional,TFRelevanceFieldModel>*relevanceWhere;


/** 选项数组 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerOptionModel>*entrys;

/** 依赖选项数组 */
@property (nonatomic, strong) NSArray <Ignore,TFCustomerOptionModel>*controlEntrys;

/** 子表单数组 */
@property (nonatomic, strong) NSArray <Optional,TFCustomerRowsModel>*componentList;

/** 子表单默认值 */
@property (nonatomic, strong) NSArray <Optional>*defaultSubform;

/** "defaultEntrys" : {
 "threeDefaultValueColor" : "",
 "twoDefaultValueId" : "0",
 "threeDefaultValueId" : "",
 "twoDefaultValueColor" : "#FFFFFF",
 "twoDefaultValue" : "二级选项1",
 "oneDefaultValue" : "一级选项1",
 "threeDefaultValue" : "",
 "oneDefaultValueColor" : "#FFFFFF",
 "oneDefaultValueId" : "0"
 }, */

/** 多级下拉默认值 */
@property (nonatomic, strong) TFMultiOptionalDefaultModel <Optional>*defaultEntrys;

/** 记录为子表单的row */
@property (nonatomic, copy) NSString <Ignore>*subformName;


/** 存放复制的子表单 */
@property (nonatomic, strong) NSMutableArray <Ignore>*subforms;

/** 选择 */
@property (nonatomic, strong) NSMutableArray <Optional>*selects;

/** 字段值 */
@property (nonatomic, copy) NSString <Optional>*fieldValue;

/** 组件高度 */
@property (nonatomic, strong) NSNumber <Ignore>*height;
/** 组件高度 */
@property (nonatomic, strong) NSValue <Ignore>*contentSize;

/** 保存其他数据 */
@property (nonatomic, strong) NSMutableDictionary <Ignore>*otherDict;

/** 联动字段 1:为联动 0 or nil:不为联动 */
@property (nonatomic, copy) NSString <Ignore>*linkage;
/** 第几个栏目 */
@property (nonatomic, strong) NSNumber <Ignore>*position;
/** subformItemId */
@property (nonatomic, strong) NSNumber <Optional>*subformItemId;

@end
