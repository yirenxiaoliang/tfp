//
//  TFTodayTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjTaskModel.h"

@interface TFTodayTaskModel : JSONModel

/** 今天任务列表 */
@property (nonatomic, strong) NSArray <Optional,TFProjTaskModel>*todayTaskList;

/** 任务完成数 */
@property (nonatomic, strong) NSNumber <Optional>*isFinishCount;
/** 任务数 */
@property (nonatomic, strong) NSNumber <Optional>*taskCount;
@end

