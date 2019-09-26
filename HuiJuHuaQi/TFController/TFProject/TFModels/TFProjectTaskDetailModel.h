//
//  TFProjectTaskDetailModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"
#import "TFProjTaskModel.h"
#import "TFProjectListItemModel.h"
#import "TFFileModel.h"
#import "HQEmployModel.h"

@interface TFProjectTaskDetailModel : HQBaseVoModel

///** 点赞 */
//@property (nonatomic, strong) NSNumber <Optional>*isLike;
///** 点赞列表 */
//@property (nonatomic, strong) NSArray <Optional,HQEmployModel>*isLikeList;
///** 任务item */
//@property (nonatomic, strong) TFProjTaskModel <Optional>*projTask;
///** 执行者s */
//@property (nonatomic, strong) NSArray <Optional,HQEmployModel>*excutors;
///** 协作者s */
//@property (nonatomic, strong) NSArray <Optional,HQEmployModel>*collaborator;
///** 任务列表item */
//@property (nonatomic, strong) TFProjectListItemModel <Optional>*projTaskList;
///** 文件列表 */
//@property (nonatomic, strong) NSArray <Optional,TFFileModel>*projAttachs;



/**创建时间*/
@property (nonatomic, strong) NSNumber <Optional>*createTime;
/**任务标题*/
@property (nonatomic, copy) NSString <Optional>*title;
/**任务描述*/
@property (nonatomic, copy) NSString <Optional>*descript;
/**截至时间*/
@property (nonatomic, strong) NSNumber <Optional>*deadline;
/**截至时间类型 2时间点 1时间段*/
@property (nonatomic, strong) NSNumber <Optional>*deadlineType;
/**截至时间单位 1分钟 2小时 3天 */
@property (nonatomic, strong) NSNumber <Optional>*deadlineUnit;
/**是否公开: 1=仅协作人可见;0=所有人可见*/
@property (nonatomic, strong) NSNumber <Optional>*isPublic;
/**我点赞的点赞Id,空则没点赞过*/
@property (nonatomic, strong) NSNumber <Optional>*myUpvoteId;
/**执行人员工Id*/
@property (nonatomic, strong) NSNumber <Optional>*executor;
/**执行人名称*/
@property (nonatomic, copy) NSString <Optional>*executorName;
/**执行人图像*/
@property (nonatomic, copy) NSString <Optional>*executorPhotograph;
/**创建人员工Id*/
@property (nonatomic, strong) NSNumber <Optional>*creatorId;
/**创建人名称*/
@property (nonatomic, copy) NSString <Optional>*creatorName;
/**创建人图像*/
@property (nonatomic, copy) NSString <Optional>*creatorPhotograph;
/**创建人职位*/
@property (nonatomic, copy) NSString <Optional>*creatorPosition;
/**任务父ID*/
@property (nonatomic, strong) NSNumber <Optional>*parentId;
/**子任务总数*/
@property (nonatomic, strong) NSNumber <Optional>*subTaskCount;
/**子任务完成数*/
@property (nonatomic, strong) NSNumber <Optional>*subTaskFinishCount;
/** 标签列表 */
@property (nonatomic, strong) NSMutableArray <Optional,TFProjLabelModel>*labels;
/**协作人列表*/
@property (nonatomic, strong) NSArray <Optional,HQEmployModel>*teamEmployeeIds;
/** 子任务列表 */
@property (nonatomic, strong) NSArray <TFProjTaskModel,Optional>*subtask;
/**附件*/
@property (nonatomic, strong) NSArray <Optional,TFFileModel>*attachments;
/**点赞人列表*/
@property (nonatomic, strong) NSArray <Optional,HQEmployModel>*taskUpvotes;
/**任务列表id*/
@property (nonatomic, strong) NSNumber <Optional>*taskListId;
/**项目id*/
@property (nonatomic, strong) NSNumber <Optional>*projectId;
/**完成时间*/
@property (nonatomic, strong) NSNumber <Optional>*finishTime;
/**任务列表名*/
@property (nonatomic, copy) NSString <Optional>*taskListName;
/**任务状态: 0=未完成;1=已完成;3=已停用*/
@property (nonatomic, strong) NSNumber <Optional>*taskStatus;
/**任务优先级*/
@property (nonatomic, strong) NSNumber <Optional>*priority;
/**更新时间*/
@property (nonatomic, strong) NSNumber <Optional>*updateTime;
/**激活次数*/
@property (nonatomic, strong) NSNumber <Optional>*activeCount;
/**重复*/
@property (nonatomic, strong) NSNumber <Optional>*isCycle;
/** 任务放置位置:1=在超期列表中;2=今天要做列表中;3=明天要做列表中;4=以后要做列表中*/
@property (nonatomic, strong) NSNumber <Optional>*inType;

/** 审批权限 */
@property (nonatomic, strong) NSNumber <Optional>*approvePermission;
/** 任务权限 */
@property (nonatomic, strong) NSNumber <Optional>*taskPermission;
/** 超期 */
@property (nonatomic, strong) NSNumber <Optional>*isOverdue;
/** 审批id */
@property (nonatomic, strong) NSNumber <Optional>*approveId;



@end
