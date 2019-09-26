//
//  TFProjectRoleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectRoleController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** recordId */
@property (nonatomic, strong) NSNumber *recordId;

/** roleId */
@property (nonatomic, strong) NSNumber *roleId;

/** 回调扫刷新 */
@property (nonatomic, copy) ActionParameter actionParameter;


@end
