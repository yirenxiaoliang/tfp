//
//  HQTFDepartPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
    
    ControllerTypeDepartment,// 部门成员
    ControllerTypeContact    // 客户成员
    
}ControllerType;

@interface HQTFDepartPeopleController : HQBaseViewController

/** ControllerType */
@property (nonatomic, assign) ControllerType type;

@end
