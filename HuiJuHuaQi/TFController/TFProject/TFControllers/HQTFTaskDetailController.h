//
//  HQTFTaskDetailController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQTFCreatTaskModel.h"
#import "TFProjectTaskListModel.h"
#import "TFProjTaskModel.h"
#import "TFProjectSeeModel.h"

@interface HQTFTaskDetailController : HQBaseViewController

/** TFProjTaskModel */
@property (nonatomic, strong) TFProjTaskModel *projectTask;
/** TFProjTaskModel */
@property (nonatomic, strong) TFProjectSeeModel *projectSeeModel;


@end
