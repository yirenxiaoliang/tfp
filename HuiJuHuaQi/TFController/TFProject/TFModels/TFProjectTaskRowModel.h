//
//  TFProjectTaskRowModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"
@interface TFProjectTaskRowModel : HQBaseVoModel

/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*projectId;
/** 负责人id */
@property (nonatomic, strong) NSNumber <Optional>*principalId;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*creatorId;
/** 任务类型 */
@property (nonatomic, strong) NSNumber <Optional>*taskType;
/** 是否公开 */
@property (nonatomic, strong) NSNumber <Optional>*isPublic;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 列表名 */
@property (nonatomic, copy) NSString <Optional>*listName;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;


@end
