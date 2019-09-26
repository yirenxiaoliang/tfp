//
//  TFKnowledgeVersionController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFKnowledgeVersionModel.h"

@interface TFKnowledgeVersionController : HQBaseViewController

/** 数据ID */
@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, strong) TFKnowledgeVersionModel *model;

@property (nonatomic, copy) ActionParameter parameter;

@end
