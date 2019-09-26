//
//  TFProjectNodeModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/25.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFProjectNodeModel

@end

@interface TFProjectNodeModel : JSONModel

/** 节点类型 0:根节点，1:分类，2:主任务，3:子任务 */
@property (nonatomic, strong) NSNumber <Optional>*node_type;
/** 节点层级 */
@property (nonatomic, strong) NSNumber <Optional>*node_level;
/** 项目编号*/
@property (nonatomic, strong) NSNumber <Optional>*project_id;

@property (nonatomic, strong) NSNumber <Optional>*data_id;
/** 节点code和部门code类似，便于上级搜索下级 */
@property (nonatomic, copy) NSString <Optional>*node_code;
/** 父节点编号*/
@property (nonatomic, strong) NSNumber <Optional>*parent_id;

@property (nonatomic, copy) NSString <Optional>*is_mileage;
/** 分类名称 */
@property (nonatomic, copy) NSString <Optional>*node_name;
/** 分类编号 */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 排序 */
@property (nonatomic, strong) NSNumber <Optional>*sort;
/** 子节点集合 */
@property (nonatomic, strong) NSArray <TFProjectNodeModel,Optional>*child;

/************************** 是任务的有下列字段 ******************************/
/** 任务名称 */
@property (nonatomic, copy) NSString <Optional>*task_name;
/** 执行人 */
@property (nonatomic, strong) NSArray <TFEmployModel,Optional>*personnel_principal;
/** 截止时间 */
@property (nonatomic, strong) NSNumber <Optional>*datetime_deadline;
/** 自定义详情数据 */
@property (nonatomic, strong) NSDictionary <Optional>*task_info;

/** 选中 */
@property (nonatomic, strong) NSNumber <Ignore>*select;
@end

NS_ASSUME_NONNULL_END
