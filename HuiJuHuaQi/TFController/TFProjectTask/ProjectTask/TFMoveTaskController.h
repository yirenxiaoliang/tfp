//
//  TFMoveTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFMoveTaskController : HQBaseViewController

/** 区别移动和复制 */
@property (nonatomic, assign) NSInteger isCopy;

/** type 0:移动任务主页  1:任务分组  2:任务列 */
@property (nonatomic, assign) NSInteger type;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** startSectionId */
@property (nonatomic, strong) NSNumber *startSectionId;

/** rowId */
@property (nonatomic, strong) NSNumber *rowId;

/** 任务id */
@property (nonatomic, strong) NSNumber *taskId;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;


@end
