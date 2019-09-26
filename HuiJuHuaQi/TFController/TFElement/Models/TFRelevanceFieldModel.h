//
//  TFRelevanceFieldModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFRelevanceFieldModel 

@end

@interface TFRelevanceFieldModel : JSONModel<NSCopying,NSMutableCopying>

/** 关联id */
@property (nonatomic, copy) NSString <Optional>*fieldId;
/** 关联名称 */
@property (nonatomic, copy) NSString <Optional>*fieldName;
/** 关联显示 */
@property (nonatomic, copy) NSString <Optional>*fieldLabel;
/** 关联显示 */
@property (nonatomic, copy) NSString <Optional>*operatorType;
/** 关联显示 */
@property (nonatomic, copy) NSString <Optional>*value;

@end
