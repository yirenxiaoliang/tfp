//
//  TFAutoMatchDataListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceTradeModel.h"

@interface TFAutoMatchDataListController : HQBaseViewController

/** 匹配数据 */
@property (nonatomic, strong) TFRelevanceTradeModel *relevance;

/** dataId : 该条数据id */
@property (nonatomic, strong) NSNumber *dataId;

/** 该条数据id权限 */
@property (nonatomic, strong) NSNumber *dataAuth;

@end
