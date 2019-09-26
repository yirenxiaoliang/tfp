//
//  HQScheduleTimeViewController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface HQScheduleTimeViewController : HQBaseViewController

@property (nonatomic, strong) NSNumber *deadlineType;

/** date 初始化时间 */
@property (nonatomic, copy) NSString *date;

/** 开始时间 */
@property (nonatomic, copy) NSString *startTime;

/** 截止时间 */
@property (nonatomic, copy) NSString *endTime;

/** 开始日期 */
@property (nonatomic, copy) NSString *startDate;

/** 截止日期 */
@property (nonatomic, copy) NSString *endDate;

/** 开始时间就选择日期 */
@property (nonatomic, assign) NSInteger startId;

/** 截止时间就选择日期 */
@property (nonatomic, assign) NSInteger endId;

//是否选择了时间
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSDate *yearDate;

@end
