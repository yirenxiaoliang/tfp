//
//  TFReferenceListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFFieldNameModel.h"

@interface TFReferenceListModel : JSONModel


/** id */
@property (nonatomic, strong) TFFieldNameModel <Optional>*id;

/** row */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel>*row;


/** relationField */
@property (nonatomic, strong) NSDictionary <Ignore>*relationField;


@property (nonatomic, strong) NSNumber <Ignore>*select;

@end
