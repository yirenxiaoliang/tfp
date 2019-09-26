//
//  TFRemainTimeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFRemainTimeController : HQBaseViewController

/** taskId 任务id  */
@property (nonatomic, strong) NSNumber *taskId;
/** taskType 0:项目任务任务 1:项目任务子任务 2:个人任务任务 3:个人任务子任务*/
@property (nonatomic, assign) NSInteger taskType;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;


@end
