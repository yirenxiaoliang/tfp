//
//  HQTFCreatTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjTaskModel.h"

@interface HQTFCreatTaskModel : JSONModel

/**  */
@property (nonatomic, strong) TFProjTaskModel *projTask;


///** 任务内容 */
//@property (nonatomic, copy) NSString *content;
///** 默认0任务 1子任务 */
//@property (nonatomic, assign) NSInteger isSubtask;
///** 截至时间类型 默认0时间点 1分钟 2小时 3天 4周 5月 6年 7秒 */
//@property (nonatomic, assign) NSInteger deadlineType;
///** 父任务id（新建子任务时要传） */
//@property (nonatomic, strong) NSNumber * parentId;
///** 优先级 */
//@property (nonatomic, strong) NSNumber *priority;
///** 截止日期 */
//@property (nonatomic, strong) NSNumber *deadline;
///** 任务描述 */
//@property (nonatomic, copy) NSString *descript;
///** 0公开 1仅参与人可见 */
//@property (nonatomic, strong) NSNumber *isPublic;
///** 任务所属列表id */
//@property (nonatomic, strong) NSNumber *taskListId;
///** 任务的执行人id */
//@property (nonatomic, strong) NSMutableArray *employeeIds;
///** 任务重复性 */
//@property (nonatomic, copy) NSString *repeat;
//
//
//
///** 协作人 */
//@property (nonatomic, strong) NSMutableArray *cooperations;
///** 金额 */
//@property (nonatomic, strong) NSNumber *money;
///** 标签 */
//@property (nonatomic, strong) NSMutableArray *labels;
///** 文件 */
//@property (nonatomic, strong) NSMutableArray *files;
///** 任务检测项 */
//@property (nonatomic, strong) NSMutableArray *tests;



/** 增加执行者s */
@property (nonatomic, strong) NSMutableArray *addExcutorIds;
/** 标签s */
@property (nonatomic, strong) NSMutableArray *labels;
/** 要添加的协作人ids */
@property (nonatomic, strong) NSMutableArray *addCollaboratorIds;
/** 要添加的关联文件对象 */
@property (nonatomic, strong) NSMutableArray *addAttaches;

/** isLike */
@property (nonatomic, strong) NSNumber *isLike;


@end
