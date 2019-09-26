//
//  TFWorkBenchModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseResponseModel.h"
#import "TFTodayTaskModel.h"
#import "TFTomorrowTaskModel.h"
#import "TFFutureTaskModel.h"
#import "TFOverdueTaskModel.h"


@interface TFWorkBenchModel : HQBaseResponseModel

/** 超期任务 */
@property (nonatomic, strong) TFOverdueTaskModel <Optional>*overdueTask;
/** 今日任务 */
@property (nonatomic, strong) TFOverdueTaskModel <Optional>*todayTask;
/** 明日任务 */
@property (nonatomic, strong) TFOverdueTaskModel <Optional>*tomorrowTask;
/** 以后任务 */
@property (nonatomic, strong) TFOverdueTaskModel <Optional>*futureTask;


@end
