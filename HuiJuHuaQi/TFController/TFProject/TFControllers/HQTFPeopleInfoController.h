//
//  HQTFPeopleInfoController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQEmployModel.h"
#import "TFProjectItem.h"

@interface HQTFPeopleInfoController : HQBaseViewController

/** 成员 */
@property (nonatomic, strong) HQEmployModel *participant;

/** TFProjectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

@end
