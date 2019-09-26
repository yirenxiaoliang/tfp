//
//  TFStatisticsListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomPageModel.h"
#import "TFStatisticsItemModel.h"

@interface TFStatisticsListModel : JSONModel

/** pageInfo */
@property (nonatomic, strong) TFCustomPageModel<Optional> *pageInfo;

/** data */
@property (nonatomic, strong) NSArray <TFStatisticsItemModel,Optional> *list;
/** data */
@property (nonatomic, strong) NSArray <TFStatisticsItemModel,Optional> *data;


@end
