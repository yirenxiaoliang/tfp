//
//  TFApprovalMainController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFApprovalMainController : HQBaseViewController

/** type 0:normal  3:项目引用 */
@property (nonatomic, assign) NSInteger type;

/** parameterAction */
@property (nonatomic, copy) ActionParameter parameterAction;


@property (nonatomic, strong) NSNumber *selectIndex;

@end
