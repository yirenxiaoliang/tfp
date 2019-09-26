//
//  TFProjectDetailTabBarController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectDetailTabBarController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** TFProjectModel */
@property (nonatomic, strong) TFProjectModel *projectModel;

/** refresh */
@property (nonatomic, copy) ActionHandler refresh;

/** deleteAction */
@property (nonatomic, copy) ActionHandler deleteAction;

@property (nonatomic, assign) BOOL createPush;

@end
