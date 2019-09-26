//
//  TFCalendarMonthModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCalendarMonthItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFCalendarMonthModel : JSONModel

/** 月 */
@property (nonatomic, strong) NSNumber<Optional> *month;
/** 年 */
@property (nonatomic, strong) NSNumber<Optional> *year;
/** 月数据 */
@property (nonatomic, strong) NSArray<TFCalendarMonthItemModel,Optional> *dateList;

@end

NS_ASSUME_NONNULL_END
