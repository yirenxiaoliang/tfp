//
//  TFSelectStatusModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAtdClassModel.h"

@interface TFSelectStatusModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*titleStr;
@property (nonatomic, copy) NSString <Optional>*name;
/** 是否折叠 */
@property (nonatomic, strong) NSNumber <Optional>*isFold;

@property (nonatomic, strong) NSMutableArray <TFAtdClassModel,Optional>*dataList;

@end
