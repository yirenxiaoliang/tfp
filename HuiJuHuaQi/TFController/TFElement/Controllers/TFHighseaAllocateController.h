//
//  TFHighseaAllocateController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFHighseaAllocateController : HQBaseViewController

/** dataId */
@property (nonatomic, strong) NSNumber *dataId;
/** bean */
@property (nonatomic, copy) NSString *bean;
/** seaPoolId */
@property (nonatomic, strong) NSNumber *seaPoolId;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
