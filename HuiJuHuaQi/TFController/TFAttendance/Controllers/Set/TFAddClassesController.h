//
//  TFAddClassesController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAddClassesController : HQBaseViewController

/** 0:新增 1:详情和编辑 */
@property (nonatomic, assign) NSInteger classType;

@property (nonatomic, strong) NSNumber *classId;

@property (nonatomic, copy) ActionHandler refresh;

@end
