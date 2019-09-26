//
//  HQTFProjectSeeBoardController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectItem.h"

@interface HQTFProjectSeeBoardController : HQBaseViewController

/** 项目类型 */
@property (nonatomic, assign) ProjectSeeBoardType type;

/** projectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;


@end
