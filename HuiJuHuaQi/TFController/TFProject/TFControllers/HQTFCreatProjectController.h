//
//  HQTFCreatProjectController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQTFCreatProjectModel.h"
#import "TFProjectItem.h"

typedef enum {
    CreatProjectControllerTypeCreate, // 创建
    CreatProjectControllerTypeEdit    // 编辑
}CreatProjectControllerType;

@interface HQTFCreatProjectController : HQBaseViewController

/** creatProject */
@property (nonatomic, strong) HQTFCreatProjectModel *creatProject;

/** CreatProjectControllerType */
@property (nonatomic, assign) CreatProjectControllerType type;

/** projectItem */
@property (nonatomic, strong) TFProjectItem *projectItem;

@end
