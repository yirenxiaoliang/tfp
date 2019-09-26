//
//  TFPCMapController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//


#import "HQBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TFLocationModel.h"
#import "TFPunchViewModel.h"


@interface TFPCMapController : HQBaseViewController

/** 打卡地址s */
@property (nonatomic, strong) NSArray *locations;

@property (nonatomic, assign) long long punchDate;

@property (nonatomic, strong) TFPunchViewModel *punchViewModel;

/** 0：外勤， 1：查看 */
@property (nonatomic, assign) NSInteger type;

@end

