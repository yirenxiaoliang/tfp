//
//  TFProjectLabelController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

@interface TFProjectLabelController : HQBaseViewController

@property (nonatomic, strong) TFProjectModel *projectModel;
/** type 0:项目标签 1:标签库 2:选标签 */
@property (nonatomic, assign) NSInteger type;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

/** selectLabels */
@property (nonatomic, strong) NSArray *selectLabels;


@end
