//
//  TFAtdClassListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFAtdClassModel.h"

@protocol TFAtdClassListModel @end

@interface TFAtdClassListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <TFAtdClassModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@property (nonatomic, strong) NSNumber <Optional>*select;

@end
