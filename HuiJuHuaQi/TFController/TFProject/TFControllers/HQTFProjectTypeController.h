//
//  HQTFProjectTypeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
    ProjectTypeWorking,  // 进行中
    ProjectTypeOutDate,  // 已超期
    ProjectTypeFinished, // 已完成
    ProjectTypePaused,   // 已暂停
    ProjectTypeStar,     // 收藏夹
    ProjectTypeFocus     // 回收站
}ProjectType;

@interface HQTFProjectTypeController : HQBaseViewController

/** ProjectType */
@property (nonatomic, assign) ProjectType projectType;


@end
