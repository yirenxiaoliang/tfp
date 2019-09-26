//
//  TFGroupATPeopleController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/1.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFGroupATPeopleController : HQBaseViewController

/** type 0:显示所有 1：移除 2:AT 3:转让群主 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSNumber *groupId;

@property (nonatomic,strong) NSMutableArray *memberArr;

@property (nonatomic, copy ) ActionParameter actionParameter;

@property (nonatomic, copy )  ActionHandler actionHandler;

@end
