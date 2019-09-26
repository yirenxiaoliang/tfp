//
//  TFCalendarMonthItemModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/14.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPunchCardInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TFCalendarMonthItemModel <NSObject>

@end

@interface TFCalendarMonthItemModel : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *date;
@property (nonatomic, copy) NSString<Optional> *state;
@property (nonatomic, copy) NSString<Optional> *groupName;
@property (nonatomic, strong) NSArray<TFPunchCardInfoModel,Optional> *attendanceList;

@end

NS_ASSUME_NONNULL_END
