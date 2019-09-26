//
//  TFProjectSectionModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectRowModel.h"

@protocol TFProjectSectionModel

@end

@interface TFProjectSectionModel : JSONModel

/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*project_id;

/** 任务分组 */
@property (nonatomic, strong) NSNumber <Optional>*id;

/** sort */
@property (nonatomic, strong) NSNumber <Optional>*sort;

/** main_id */
@property (nonatomic, strong) NSNumber <Optional>*main_id;

/** 任务分组名称 */
@property (nonatomic, copy) NSString <Optional>*name;
/** 模块id */
@property (nonatomic, strong) NSNumber <Optional>*module_id;
/** 模块bean */
@property (nonatomic, copy) NSString <Optional>*module_bean;
/** 数据类型 */
@property (nonatomic, strong) NSNumber <Optional>*dataType;
/** 应用id */
@property (nonatomic, strong) NSNumber <Optional>*application_id;

/** 层级 */
@property (nonatomic, copy) NSString <Optional>*children_data_type;

/** flow_id：工作流 */
@property (nonatomic, copy) NSString <Optional>*flow_id;

/** subnodeArr */
@property (nonatomic, strong) NSMutableArray <TFProjectSectionModel , Optional>*subnodeArr;

/** key */
@property (nonatomic, copy) NSString <Ignore>*key;

/** 任务分组中的任务列 */
@property (nonatomic, strong) NSMutableArray <TFProjectRowModel,Optional>*tasks;

/** 任务分组中的任务列 */
@property (nonatomic, strong) NSMutableArray <Ignore>*frames;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;

/** pageNum */
@property (nonatomic, strong) NSNumber <Ignore>*pageNum;
/** pageSize */
@property (nonatomic, strong) NSNumber <Ignore>*pageSize;

@end
