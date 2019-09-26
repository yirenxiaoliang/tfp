//
//  HQTFTaskDynamicController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjTaskModel.h"
#import "TFProjectSeeModel.h"

@interface HQTFTaskDynamicController : HQBaseViewController

/** TFProjTaskModel */
@property (nonatomic, strong) TFProjTaskModel *taskDetail;
/** TFProjTaskModel */
@property (nonatomic, strong) TFProjectSeeModel *projectSeeModel;

/** type 0:评论 1：动态 */
@property (nonatomic, assign) NSInteger type;


@end
