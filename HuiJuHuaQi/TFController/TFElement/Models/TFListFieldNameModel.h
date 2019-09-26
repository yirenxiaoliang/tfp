//
//  TFListFieldNameModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFListFieldNameModel

@end

@interface TFListFieldNameModel : JSONModel

/** name */
@property (nonatomic, copy) NSString <Optional>*name;
/** label */
@property (nonatomic, copy) NSString <Optional>*label;
/** value */
@property (nonatomic, copy) id <Ignore>value;
/** color */
@property (nonatomic, copy) NSString <Optional>*color;

@end
