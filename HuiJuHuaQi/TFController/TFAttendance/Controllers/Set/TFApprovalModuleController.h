//
//  TFApprovalModuleController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/5.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFApprovalModuleController : HQBaseViewController

@property (nonatomic, copy) ActionParameter actionField;


@property (nonatomic, strong) TFModuleModel *model;
@end

NS_ASSUME_NONNULL_END
