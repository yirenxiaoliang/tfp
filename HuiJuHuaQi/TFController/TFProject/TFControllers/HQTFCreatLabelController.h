//
//  HQTFCreatLabelController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectItem.h"
#import "TFProjLabelModel.h"

@interface HQTFCreatLabelController : HQBaseViewController

/** TFProjLabelModel */
@property (nonatomic, strong) TFProjLabelModel *labelModel;
/** project */
@property (nonatomic, strong) NSNumber *projectId;

/** type 0为新建 1为修改 */
@property (nonatomic, assign) NSInteger type;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
