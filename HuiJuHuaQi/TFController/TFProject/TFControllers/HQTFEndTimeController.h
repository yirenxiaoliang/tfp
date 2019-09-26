//
//  HQTFEndTimeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface HQTFEndTimeController : HQBaseViewController

/** date 初始化时间 */
@property (nonatomic, copy) NSString *date;
/** 倒计时开关 */
@property (nonatomic, assign) BOOL on;

/** 截止时间段 */
@property (nonatomic, copy) NSString *timePeriod;

/** dealineType 截至时间类型默认 2时间点 1时间段 */
@property (nonatomic, strong) NSNumber *deadlineType;


/** dealineType 截至时间类型默认  1分钟 2小时 3天 */
@property (nonatomic, strong) NSNumber *deadlineUnit;

/** 值 */
@property (nonatomic, copy) ActionParameter timeAction;

@end
