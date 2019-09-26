//
//  TFOverdueTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjTaskModel.h"

@interface TFOverdueTaskModel : JSONModel


/** 任务列表 */
//@property (nonatomic, strong) NSArray <Optional,TFProjTaskModel>*tasks;
/** 任务列表 */
@property (nonatomic, strong) NSArray <Optional>*tasks;

/** 任务完成数 */
@property (nonatomic, strong) NSNumber <Optional>*finishTaskCount;
/** 任务数 */
@property (nonatomic, strong) NSNumber <Optional>*taskCount;

@end
