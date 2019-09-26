//
//  TFProjectSelectRowController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectSelectRowController : HQBaseViewController

/** type 0:项目 1:分组 2:列 */
@property (nonatomic, assign) NSInteger type;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;

@end
