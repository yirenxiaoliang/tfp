//
//  TFKnowledgePeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFKnowledgePeopleController : HQBaseViewController

/** type 0:阅读人 1：收藏人 2：点赞人 3：学习人*/
@property (nonatomic, assign) NSInteger type;

/** 数据ID */
@property (nonatomic, strong) NSNumber *dataId;

@end
