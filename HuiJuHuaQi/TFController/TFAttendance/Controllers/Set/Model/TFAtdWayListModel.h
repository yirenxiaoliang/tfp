//
//  TFAtdWayListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFAtdWatDataListModel.h"

@interface TFAtdWayListModel : JSONModel

@property (nonatomic, strong) NSArray <TFAtdWatDataListModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@property (nonatomic, strong) NSNumber <Optional>*select;

@end
