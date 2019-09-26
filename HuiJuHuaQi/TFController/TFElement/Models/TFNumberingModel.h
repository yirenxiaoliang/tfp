//
//  TFNumberingModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//  编号规则

#import "JSONModel.h"

@protocol TFNumberingModel

@end

@interface TFNumberingModel : JSONModel<NSMutableCopying,NSCopying>

/** 固定值 */
//@property (nonatomic, copy) NSString <Optional>*fixedValue;

/** 日期 */
@property (nonatomic, copy) NSString <Optional>*dateValue;

/** 顺序号 */
@property (nonatomic, copy) NSString <Optional>*serialValue;



@end
