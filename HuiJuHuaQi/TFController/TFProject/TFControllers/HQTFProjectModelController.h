//
//  HQTFProjectModelController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface HQTFProjectModelController : HQBaseViewController

/** 值 */
@property (nonatomic, copy) ActionParameter projectModel;

/** 选中的id */
@property (nonatomic, strong) NSNumber *categoryId;

@end
