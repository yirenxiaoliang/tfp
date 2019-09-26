//
//  TFProjectSecondController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectColumnModel.h"

@interface TFProjectSecondController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sections */
@property (nonatomic, strong) TFProjectColumnModel *projectColumnModel;

/** indexAction */
@property (nonatomic, copy) ActionParameter indexAction;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
