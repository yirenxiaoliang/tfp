//
//  TFAttendanceGroupModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/13.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFAttendanceGroupModel <NSObject>

@end

@interface TFAttendanceGroupModel : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *name;

@end

NS_ASSUME_NONNULL_END
