//
//  TFColumnListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectColumnModel.h"

@interface TFColumnListController : HQBaseViewController

/** columns */
@property (nonatomic, strong) NSArray *columns;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
