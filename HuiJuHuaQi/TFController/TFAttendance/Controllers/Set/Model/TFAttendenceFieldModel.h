//
//  TFAttendenceFieldModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
/**
 "subfield" : "systemInfo",
 "field_name" : "datetime_modify_time",
 "editDisable" : "0",
 "type" : "datetime",
 "field_label" : "修改时间"
 */

@interface TFAttendenceFieldModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*subfield;
@property (nonatomic, copy) NSString <Optional>*field_name;
@property (nonatomic, copy) NSString <Optional>*editDisable;
@property (nonatomic, copy) NSString <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*field_label;
@property (nonatomic, strong) NSNumber <Ignore>*select;

@end

NS_ASSUME_NONNULL_END
