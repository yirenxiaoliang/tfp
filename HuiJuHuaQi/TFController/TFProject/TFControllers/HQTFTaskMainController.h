//
//  HQTFTaskMainController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "YPTabBarController.h"
#import "TFProjTaskModel.h"
#import "TFProjectSeeModel.h"

@interface HQTFTaskMainController : YPTabBarController

/** projectTask */
@property (nonatomic, strong) TFProjTaskModel *projectTask;

/** TFProjTaskModel */
@property (nonatomic, strong) TFProjectSeeModel *projectSeeModel;

@end
