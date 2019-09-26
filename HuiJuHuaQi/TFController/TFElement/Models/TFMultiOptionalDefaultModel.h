//
//  TFMultiOptionalDefaultModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFMultiOptionalDefaultModel 

@end

@interface TFMultiOptionalDefaultModel : JSONModel

/**
 "threeDefaultValueColor" : "",
 "twoDefaultValueId" : "0",
 "threeDefaultValueId" : "",
 "twoDefaultValueColor" : "#FFFFFF",
 "twoDefaultValue" : "二级选项1",
 "oneDefaultValue" : "一级选项1",
 "threeDefaultValue" : "",
 "oneDefaultValueColor" : "#FFFFFF",
 "oneDefaultValueId" : "0" */

/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*oneDefaultValueId;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*oneDefaultValueColor;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*oneDefaultValue;


/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*twoDefaultValueId;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*twoDefaultValueColor;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*twoDefaultValue;


/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*threeDefaultValueId;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*threeDefaultValueColor;
/** oneDefaultValueId */
@property (nonatomic, copy) NSString <Optional>*threeDefaultValue;

@end
