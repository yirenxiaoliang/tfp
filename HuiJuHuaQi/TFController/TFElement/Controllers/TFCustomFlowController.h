//
//  TFCustomFlowController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCustomFlowController : HQBaseViewController

/** bean */
@property (nonatomic, copy) NSString *bean;
/** dataId */
@property (nonatomic, strong) NSNumber *dataId;
/** processInstanceId */
@property (nonatomic, strong) NSNumber *processInstanceId;

@end
