//
//  TFMainScheduleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFMainScheduleModel : JSONModel

/** 日程类型 */
@property (nonatomic, assign) NSInteger scheduleType;
/** 日程标题 */
@property (nonatomic, copy) NSString *scheduleTitle;
/** 日程内容 */
@property (nonatomic, copy) NSString *scheduleContent;
/** 日程来源 */
@property (nonatomic, copy) NSString *scheduleSource;


@end
