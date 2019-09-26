//
//  TFCompanyCircleDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFCompanyCircleFrameModel.h"

@interface TFCompanyCircleDetailController : HQBaseViewController

/** frameModel */
@property (nonatomic, strong) TFCompanyCircleFrameModel *frameModel;

/** refreshAction */
@property (nonatomic, copy) ActionParameter refreshAction;
/** refreshAction */
@property (nonatomic, copy) ActionParameter deleteAction;

@end
