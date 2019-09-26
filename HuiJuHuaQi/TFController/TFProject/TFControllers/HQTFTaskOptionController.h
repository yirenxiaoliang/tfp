//
//  HQTFTaskOptionController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQTFOptionModel.h"
#import "TFProjectSeeModel.h"

@interface HQTFTaskOptionController : HQBaseViewController

/** listItem */
@property (nonatomic, strong) TFProjectSeeModel *listItem;
/** 负责人 */
@property (nonatomic, strong) NSMutableArray *managers;


/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

@end
