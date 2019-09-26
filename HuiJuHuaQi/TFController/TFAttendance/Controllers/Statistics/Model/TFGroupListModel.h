//
//  TFGroupListModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFAttendanceGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFGroupListModel : JSONModel

@property (nonatomic, strong) NSArray <TFAttendanceGroupModel,Optional>*dataList;

@property (nonatomic, strong) NSNumber <Optional>*list_set_type;

@end

NS_ASSUME_NONNULL_END
