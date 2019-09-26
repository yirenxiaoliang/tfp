//
//  TFChartListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFStatisticsItemModel.h"

@interface TFChartListController : HQBaseViewController

/** lists */
@property (nonatomic, strong) NSMutableArray *lists;

/** model */
@property (nonatomic, strong) TFStatisticsItemModel *model;

/** refresh */
@property (nonatomic, copy) ActionParameter refresh;

@end
