//
//  TFProjectModelPreviewController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectModelPreviewController : HQBaseViewController

/** templateId */
@property (nonatomic, strong) NSNumber *templateId;

/** sureAction */
@property (nonatomic, copy) ActionHandler sureAction;

@end
