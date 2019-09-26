//
//  TFPCFinishController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFPCFinishController : HQBaseViewController

/** type 0:已打卡 1：未打卡  */
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong) NSArray *peoples;

@end
