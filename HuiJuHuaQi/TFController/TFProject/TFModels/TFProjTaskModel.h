//
//  TFProjTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"
#import "TFProjLabelModel.h"
#import "HQEmployModel.h"

@protocol TFProjTaskModel
@end

@interface TFProjTaskModel : HQBaseVoModel

///** 是否完成，检测项全完成时，任务完成，反之亦然 */
//@property (nonatomic, strong) NSNumber<Optional> *isFinish;
///** 创建人id */
//@property (nonatomic, strong) NSNumber<Optional> *creatorId;
///** 创建人名 */
//@property (nonatomic, strong) NSNumber<Optional> *creatorName;
///** 任务内容 */
//@property (nonatomic, copy) NSString<Optional> *content;
///** 子任务的总数 */
//@property (nonatomic, strong) NSNumber<Optional> *childTaskCount;
///** 完成的子任务的总数 */
//@property (nonatomic, strong) NSNumber<Optional> *childTaskFinished;
///** 关联项总数 */
//@property (nonatomic, strong) NSNumber<Optional> *relatedItemCount;
///** 项目id */
//@property (nonatomic, strong) NSString<Optional> *projectName;
///** 公司id */
//@property (nonatomic, strong) NSNumber<Optional> *companyId;
///** 最新更新时间 */
//@property (nonatomic, strong) NSNumber<Optional> *lastUpdateTime;
///** 是否为子任务 */
//@property (nonatomic, strong) NSNumber<Optional> *isSubtask;
///** 序列号 */
//@property (nonatomic, strong) NSNumber<Optional> *serialNumber;
///** 完成时间 */
//@property (nonatomic, strong) NSNumber<Optional> *finishTime;
///** 任务列表id */
//@property (nonatomic, strong) NSNumber<Optional> *taskListId;



/** 是否有审批 */
@property (nonatomic, strong) NSNumber <Optional>*isHasApprove;
/** 审批id */
@property (nonatomic, strong) NSNumber <Optional>*approveId;
/** 任务权限 
 200: 更改任务状态、截止时间、仅协作人可见、创建子任务
 201: 更改任务状态、截止时间、仅协作人可见、创建子任务、修改执行人
 300: 提出任务延期申请权限
 301: 审批任务延期申请权限
 
 */
@property (nonatomic, strong) NSArray <Optional>*taskPermissions;
/** 标签id列表 */
@property (nonatomic, strong) NSMutableArray <Optional>*labelIds;

/** 参与人列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*teamUsers;

/** 参与人列表 */
@property (nonatomic, strong) NSMutableArray <Optional>*teamUserIds;

/** 执行人列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*excutors;
/** 子任务 */
@property (nonatomic, strong) NSArray <TFProjTaskModel,Optional>*subtask;

/** 截至时间类型默认 2时间点 1时间段 */
@property (nonatomic, strong) NSNumber<Optional> *deadlineType;
/** 是否重复 */
@property (nonatomic, strong) NSNumber<Optional> *isRepeat;
/** 是否重复 */
@property (nonatomic, strong) NSNumber<Optional> *isCycle;
/** 项目id */
@property (nonatomic, strong) NSNumber<Optional> *projectId;
/** 项目名字 */
@property (nonatomic, strong) NSString<Optional> *projectName;

/** -------------------------------------------------------- */

/** 用于移动 */
@property (nonatomic, strong) NSNumber<Optional> *inTime;
/** 创建时间 */
@property (nonatomic, strong) NSNumber<Optional> *createTime;
/** 数据更新时间 */
@property (nonatomic, strong) NSNumber<Optional> *updateTime;
/** 任务的完成时间 */
@property (nonatomic, strong) NSNumber<Optional> *finishTime;
/** 所属列表id */
@property (nonatomic, strong) NSNumber<Optional> *taskListId;
/**任务id*/
@property (nonatomic, strong) NSNumber<Optional> *taskId;
/**任务状态:0=未完成;1=已完成;3=已停用*/
@property (nonatomic, strong) NSNumber<Optional> *taskStatus;
/** 任务放置位置:1=在超期列表中;2=今天要做列表中; 3=明天要做列表中;4=以后要做列表中*/
@property (nonatomic, strong) NSNumber<Optional> *inType;
/**父任务Id*/
@property (nonatomic, strong) NSNumber<Optional> *parentId;
/**任务标题*/
@property (nonatomic, copy) NSString<Optional> *title;
/**任务激活次数*/
@property (nonatomic, strong) NSNumber<Optional> *activeCount;
/**截止时间*/
@property (nonatomic, strong) NSNumber<Optional> *deadline;
/** 截至时间单位:0=秒;1=分钟;2=小时;3=天;4=周;5=月;6=年 */
@property (nonatomic, strong) NSNumber<Optional> *deadlineUnit;
/**延时记录id(还没实现)*/
@property (nonatomic, strong) NSNumber<Optional> *delayRecordId;
/** 优先级别：0普通、1紧急、2非常紧急 */
@property (nonatomic, strong) NSNumber<Optional> *priority;
/** 是否公开:0=私有;1=公开(则任务列表参与人都可见)*/
@property (nonatomic, strong) NSNumber<Optional> *isPublic;
/**任务描述*/
@property (nonatomic, copy) NSString<Optional> *descript;
/** 执行人id*/
@property (nonatomic, strong) NSNumber<Optional> *executor;
/** 执行人id*/
@property (nonatomic, strong) NSNumber<Optional> *executorId;
/**执行人名称*/
@property (nonatomic, copy) NSString<Optional> *executorName;
/**执行人名称*/
@property (nonatomic, copy) NSString<Optional> *executorlName;
/**执行人相片地址*/
@property (nonatomic, copy) NSString<Optional> *executorPhotograph;
/*执行人职位*/
@property (nonatomic, copy) NSString<Optional> *executorPosition;
/** 文件总个数 */
@property (nonatomic, strong) NSNumber<Optional> *fileCount;
/**任务是否超期:0=未超期;1=已超期*/
@property (nonatomic, strong) NSNumber <Optional>*isOverdue;
/**子任务数*/
@property (nonatomic, strong) NSNumber<Optional> *subTaskCount;
/**子任务完成数*/
@property (nonatomic, strong) NSNumber<Optional> *subTaskFinishCount;
/** 标签列表 */
@property (nonatomic, strong) NSMutableArray <Optional,TFProjLabelModel>*labels;

/** 用于工作台 */
@property (nonatomic, strong) NSNumber <Optional>*dataType;


@end
