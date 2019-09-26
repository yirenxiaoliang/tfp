//
//  TFFieldNameModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFSimpleFieldModel.h"

@protocol TFFieldNameModel
@end

@interface TFFieldNameModel : JSONModel

/** name */
@property (nonatomic, copy) NSString <Optional>*hidden;
/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** label */
@property (nonatomic, copy) NSString <Optional>*label;
/** value */
@property (nonatomic, copy) NSString <Optional>*value;
/** color */
@property (nonatomic, copy) NSString <Optional>*color;
/** other 用于时间格式 */
@property (nonatomic, copy) NSString <Optional>*other;
/** 保密*/
@property (nonatomic, copy) NSString <Optional>*secret;
/** 属性 */
@property (nonatomic, strong) TFSimpleFieldModel <Optional>*field_param;

@end
