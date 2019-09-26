//
//  TFReferenceListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceFieldModel.h"
#import "TFRelevanceTradeModel.h"

@interface TFReferenceListController : HQBaseViewController

/** bean */
@property (nonatomic, copy) NSString *bean;
/** title */
@property (nonatomic, copy) NSString *naviTitle;
/** fieldName */
@property (nonatomic, copy) NSString *fieldName;
/** dataId */
@property (nonatomic, strong) NSNumber *dataId;
/** lastDetailDict */
@property (nonatomic, strong) NSDictionary *lastDetailDict;

/** TFRelevanceTradeModel */
@property (nonatomic, strong) TFRelevanceTradeModel *tradeModel;
/** sorceBean */
@property (nonatomic, copy) NSString *sorceBean;
/** targetBean */
@property (nonatomic, copy) NSString *targetBean;

@end
