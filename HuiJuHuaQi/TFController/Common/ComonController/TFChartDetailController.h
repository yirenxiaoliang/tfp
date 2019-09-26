//
//  TFChartDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFStatisticsItemModel.h"

@interface TFChartDetailController : HQBaseViewController

/** model */
@property (nonatomic, strong) TFStatisticsItemModel *model;

/** type */
@property (nonatomic, assign) NSInteger type;


@end
