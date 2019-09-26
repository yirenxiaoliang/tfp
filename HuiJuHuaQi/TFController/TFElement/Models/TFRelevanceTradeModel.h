//
//  TFRelevanceTradeModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFRelevanceTradeModel

@end

@interface TFRelevanceTradeModel : JSONModel<NSCopying,NSMutableCopying>


/** 关联业务 */
@property (nonatomic, copy) NSString <Optional>*moduleName;
/** 关联业务显示 */
@property (nonatomic, copy) NSString <Optional>*moduleLabel;
/** 关联的数量 */
@property (nonatomic, strong) NSNumber <Optional>*totalRows;
/** fieldName:关联组件的name */
@property (nonatomic, copy) NSString <Optional>*fieldName;
/** fieldLabel:关联组件的label */
@property (nonatomic, copy) NSString <Optional>*fieldLabel;
/** relevaceKey */
@property (nonatomic, copy) NSString <Optional>*referenceField;
/** show */
@property (nonatomic, copy) NSString <Optional>*show;

/** width */
@property (nonatomic, copy) NSString <Ignore>*width;
/** height */
@property (nonatomic, copy) NSString <Ignore>*height;


/** 自动匹配字段 */
/**
 "target_bean": "bean1535959261391",
 "id": 61,
 "title": "测试后台规则一",
 "sorce_bean": "bean1535937443910"
 */

/** target_bean */
@property (nonatomic, copy) NSString <Optional>*target_bean;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** module_id */
@property (nonatomic, copy) NSNumber <Optional>*module_id;
/** title */
@property (nonatomic, copy) NSString <Optional>*chinese_name;
/** sorce_bean */
@property (nonatomic, copy) NSString <Optional>*sorce_bean;
/** condition_type 0 自定义页签 1关联关系 2邮件 3自动化匹配 */
@property (nonatomic, strong) NSNumber <Optional>*condition_type;


/** isAuto */
@property (nonatomic, copy) NSNumber <Ignore>*isAuto;







@end
