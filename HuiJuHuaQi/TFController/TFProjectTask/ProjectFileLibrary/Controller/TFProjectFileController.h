//
//  TFProjectFileController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectFileController : HQBaseViewController

@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) TFProjectModel *projectModel;

@property (nonatomic, copy) ActionParameter actionParameter;

@end
