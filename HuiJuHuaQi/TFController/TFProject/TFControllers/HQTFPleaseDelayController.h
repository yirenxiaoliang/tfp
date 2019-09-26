//
//  HQTFPleaseDelayController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjTaskModel.h"

@interface HQTFPleaseDelayController : HQBaseViewController

/** type 0:申请 1：审批*/
@property (nonatomic, assign) NSInteger type;

/** TFProjTaskModel */
@property (nonatomic, strong) TFProjTaskModel *task;

@end
