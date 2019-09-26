//
//  TFRelationModuleModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/10.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFRelationModuleModel

@end

@interface TFRelationModuleModel : JSONModel
/*0("缺卡"), 1("请假"), 2("加班"), 3("出差"), 4("销假"), 5("外出")*/ 
@property (nonatomic, copy) NSString <Optional>*relevance_status;
/** 模块名 */
@property (nonatomic, copy) NSString <Optional>*chinese_name;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*start_time;
/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*end_time;
/** data_id */
@property (nonatomic, strong) NSNumber <Optional>*data_id;
/** bean_name */
@property (nonatomic, copy) NSString <Optional>*bean_name;

@end

NS_ASSUME_NONNULL_END
