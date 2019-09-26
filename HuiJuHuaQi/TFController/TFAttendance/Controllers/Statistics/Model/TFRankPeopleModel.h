//
//  TFRankPeopleModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmployModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFRankPeopleModel : TFEmployModel

@property (nonatomic, strong) NSNumber<Optional> *real_punchcard_time;

@property (nonatomic, strong) NSNumber<Optional> *month_work_time;

@property (nonatomic, strong) NSNumber<Optional> *late_count_number;
@property (nonatomic, strong) NSNumber<Optional> *late_time_number;

@end

NS_ASSUME_NONNULL_END
