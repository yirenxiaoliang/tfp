//
//  TFCustomEmailListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFRelevanceTradeModel.h"

@interface TFCustomEmailListController : HQBaseViewController
/** model */
@property (nonatomic, strong) TFRelevanceTradeModel *relevance;
/** 邮箱列表 */
@property (nonatomic, strong) NSArray *emails;

/** 权限 */
@property (nonatomic, strong) NSNumber *dataAuth;
/** 数据ID */
@property (nonatomic, strong) NSNumber *dataId;

@end
