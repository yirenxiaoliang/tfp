//
//  TFProjectBoardController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectBoardController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) TFProjectModel *projectModel;
@end
