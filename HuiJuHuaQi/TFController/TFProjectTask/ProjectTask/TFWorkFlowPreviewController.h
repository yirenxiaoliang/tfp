//
//  TFWorkFlowPreviewController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFWorkFlowPreviewController : HQBaseViewController

/** workflowId */
@property (nonatomic, strong) NSNumber *workflowId;

/** sureAction */
@property (nonatomic, copy) ActionParameter sureAction;

@end
