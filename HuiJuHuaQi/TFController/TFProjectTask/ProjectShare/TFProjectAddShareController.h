//
//  TFProjectAddShareController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectAddShareController : HQBaseViewController

/** 0:新增 1:详情 2:编辑 */
@property (nonatomic, assign) NSInteger type;

/** 项目ID */
@property (nonatomic, strong) NSNumber *proId;

/** 分享id */
@property (nonatomic, strong) NSNumber *shareId;

/** 刷新回调 */
@property (nonatomic, copy) ActionHandler refresh;


@property (nonatomic, strong) TFProjectModel *projectModel;

@end
