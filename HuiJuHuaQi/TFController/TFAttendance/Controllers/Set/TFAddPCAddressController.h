//
//  TFAddPCAddressController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAddPCAddressController : HQBaseViewController

/** 考勤方式 0:新增 1:详情 */
@property(nonatomic, assign) NSInteger type;

/** 考勤方式Id */
@property (nonatomic, strong) NSNumber *wayId;

@property (nonatomic, copy) ActionHandler refresh;

@end
