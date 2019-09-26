//
//  TFNewMoveTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFNewMoveTaskController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** startSectionId */
@property (nonatomic, strong) NSNumber *startSectionId;

/** rowId */
@property (nonatomic, strong) NSNumber *rowId;

/** childRowId */
@property (nonatomic, strong) NSNumber *childRowId;

/** taskId */
@property (nonatomic, strong) NSNumber *taskId;


/** type 0:移动 1:复制 */
@property (nonatomic, assign) NSInteger type;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;


@end
