//
//  TFPositionManageController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFPositionManageController : HQBaseViewController

/** type 0:用于选择 1：管理 */
@property (nonatomic, assign) NSInteger type;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;


@end
