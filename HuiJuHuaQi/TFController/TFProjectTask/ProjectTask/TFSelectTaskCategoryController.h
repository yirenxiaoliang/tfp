//
//  TFSelectTaskCategoryController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/10.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFSelectTaskCategoryController : HQBaseViewController

/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

@end

NS_ASSUME_NONNULL_END
