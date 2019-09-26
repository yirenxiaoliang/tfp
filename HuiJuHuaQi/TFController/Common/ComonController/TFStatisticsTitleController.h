//
//  TFStatisticsTitleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFBeanTypeModel.h"

@interface TFStatisticsTitleController : HQBaseViewController


/** model */
@property (nonatomic, strong) TFBeanTypeModel *model;

/** refresh */
@property (nonatomic, copy) ActionParameter refresh;
@end
