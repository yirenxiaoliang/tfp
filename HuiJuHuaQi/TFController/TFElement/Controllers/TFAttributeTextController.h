//
//  TFAttributeTextController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAttributeTextController : HQBaseViewController

/** content */
@property (nonatomic, copy) NSString *content;

/** fieldLabel */
@property (nonatomic, assign) NSString *fieldLabel;

/** contentAction */
@property (nonatomic, copy) ActionParameter contentAction;

@end
