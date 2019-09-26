//
//  TFProjectSeeModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseResponseModel.h"
#import "TFProjectItem.h"
#import "TFProjTaskModel.h"


@interface TFProjectSeeModel : HQBaseResponseModel

///** project */
@property (nonatomic, strong) TFProjectItem <Optional>*project;

//
///** 看板任务分类 */
//@property (nonatomic, strong) NSArray <TFProjectTaskListModel,Optional>*projTaskLists;


/**列表名称*/
@property (nonatomic, copy) NSString <Optional>*listName;
/**列表Id*/
@property (nonatomic, strong) NSNumber <Optional>*id;
/**列表Id*/
@property (nonatomic, strong) NSNumber <Optional>*listId;
/** 是否公开:0=仅列表成员可见;1=所有人可见*/
@property (nonatomic, strong) NSNumber <Optional>*isPublic;
/**负责人Id*/
@property (nonatomic, strong) NSNumber <Optional>*principalId;
/**负责人名称*/
@property (nonatomic, copy) NSString <Optional>*principalName;
/**负责人相片地址*/
@property (nonatomic, copy) NSString <Optional>*principalPhotograph;
/*负责人职位*/
@property (nonatomic, copy) NSString <Optional>*principalPosition;
/**列表任务数*/
@property (nonatomic, strong) NSNumber <Optional>*listTaskCount;
/** 列表任务完成数*/
@property (nonatomic, strong) NSNumber <Optional>*listTaskFinishCount;
/** 列表权限 */
@property (nonatomic, strong) NSArray <Optional>*listPermissions;

/** 看板任务列表 */
@property (nonatomic, strong) NSArray <TFProjTaskModel,Optional>*tasks;


@end
