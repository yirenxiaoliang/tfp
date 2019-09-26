//
//  TFEndBeforeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFEndBeforeController : HQBaseViewController

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

/** time */
@property (nonatomic, copy) NSString *time;

/** unit */
@property (nonatomic, assign) NSInteger unit;
@end
