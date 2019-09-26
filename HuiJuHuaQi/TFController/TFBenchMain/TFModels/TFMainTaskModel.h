//
//  TFMainTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFMainTaskModel : JSONModel

/** 任务紧急度 */
@property (nonatomic, assign) NSInteger taskPriority;
/** 任务延期 */
@property (nonatomic, assign) NSInteger taskDelay;
/** 任务完成 */
@property (nonatomic, assign) NSInteger taskFinished;
/** 任务标题 */
@property (nonatomic, copy) NSString *taskTitle;
/** 任务内容 */
@property (nonatomic, copy) NSString *taskContent;
/** 任务来源 */
@property (nonatomic, copy) NSString *taskSource;
/** 任务日期 */
@property (nonatomic, strong) NSNumber *taskDate;

@end
