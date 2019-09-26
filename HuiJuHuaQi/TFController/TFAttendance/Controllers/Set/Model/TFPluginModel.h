//
//  TFPluginModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/7/3.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFPluginModel : JSONModel
/**
 "modify_time" : "",
 "modify_by" : "",
 "create_by" : 1,
 "create_time" : 1561978224847,
 
 "plugin_name" : "急速打卡",
 "id" : 1,
 "plugin_status" : 1,
 "plugin_note" : "只需要在考勤时间段内打开app，系统就会自动帮您完成打卡",
 "plugin_type" : 1
 */

/** 插件id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 插件开启状态 */
@property (nonatomic, strong) NSNumber <Optional>*plugin_status;
/** 插件类型 */
@property (nonatomic, strong) NSNumber <Optional>*plugin_type;
/** 插件名称 */
@property (nonatomic, copy) NSString <Optional>*plugin_name;
/** 插件说明 */
@property (nonatomic, copy) NSString <Optional>*plugin_note;

@end

NS_ASSUME_NONNULL_END
