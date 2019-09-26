//
//  HQCreatTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/7/27.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQCustomerModel.h"


@interface HQCreatTaskModel : JSONModel<NSCopying, NSMutableCopying>
/** 任务ID */
@property (nonatomic , copy) NSNumber *taskID;
/** 提交类型，0为创建，1为修改， 2为复制 */
@property (nonatomic, assign) NSInteger commitType;
/** 项目ID */
@property (nonatomic , copy) NSNumber *projectId;
/** 项目名称 */
@property (nonatomic , copy) NSString *projectName;
/** 项目阶段ID */
@property (nonatomic , copy) NSNumber *projectStageId;
/** 项目阶段名称 */
@property (nonatomic , copy) NSString *projectStage;
/** 任务标题 */
@property (nonatomic , copy) NSString *taskTitle;
/** 任务内容 */
@property (nonatomic , copy) NSString *taskContent;
/** 任务标签 */
@property (nonatomic , strong) NSMutableArray *taskTags;
/** 截止时间 */
@property (nonatomic , copy) NSString *endTime;
/** 截止时间 */
@property (nonatomic , assign) long long endTimeSp;
/** 负责人ID数组 */
@property (nonatomic , strong) NSMutableArray *responsiblePeopleIDs;
/** 负责人id */
@property (nonatomic , copy) NSNumber *responsiblePeopleID;
/** 抄送人ID数组(员工模型) */
@property (nonatomic , strong) NSMutableArray *prarticipantPeopleIDs;
/** 抄送人ID数组（id） */
@property (nonatomic , strong) NSMutableArray *checkers;
/** 前置任务数组 */
@property (nonatomic , strong) NSMutableArray *frontTasks;
/** 是否验收 */
@property (nonatomic , assign) BOOL check;


/** 紧急度数组 */
@property (nonatomic , strong) NSMutableArray *urgents;
/** 紧急度 */
@property (nonatomic , assign) NSInteger urgent;

/** 有无数量 0为无，1为有*/
@property (nonatomic, assign) BOOL haveNumber;
/** 数量 */
@property (nonatomic, copy) NSString *number;

/** 数量说明 */
@property (nonatomic, copy) NSString *numberDesc;
/** 有无金额 0为无，1为有*/
@property (nonatomic, assign) BOOL haveMoney;
/** 金额 */
@property (nonatomic, copy) NSString *money;
/** 费用说明 */
@property (nonatomic, copy) NSString *moneyDesc;



/** 语音操作类型:0.保持不变;1.删除旧的语音但不重新录入;2.删除旧的语音并重新录入 */
@property (nonatomic, assign) NSInteger voiceOperation;
/** 新建语音数组 */
@property (nonatomic , strong) NSMutableArray *records;
/** 网络语音数组 */
@property (nonatomic , strong) NSMutableArray *netRecords;
/** 新建录音秒数 */
@property (nonatomic , assign) NSInteger recordTime;
/** 新建本地录音URL */
@property (nonatomic , strong) NSURL * recorderUrl;
/** 网络录音地址（用于编辑、复制任务）  */
@property (nonatomic , copy) NSString *voiceUrl;


/** 关联任务数组 */
@property (nonatomic , strong) NSMutableArray *relatedTasks;
/** 关联客户数组 */
@property (nonatomic , strong) NSMutableArray *relatedCustomers;
/** 关联客户ID数组 */
@property (nonatomic , strong) NSMutableArray *relatedCustomerIDs;
/** 总的图片数组 */
@property (nonatomic , strong) NSMutableArray *pictures;
/** 网络图片数组（修改任务） */
@property (nonatomic , strong) NSMutableArray *attachments;
/** 新增图片数组（修改任务） */
@property (nonatomic , strong) NSMutableArray *addPictures;
/** 文件 */
@property (nonatomic, strong) NSMutableArray *files;
/** 任务状态 */
@property (nonatomic, assign) NSInteger taskState;


//+ (HQCommitTaskModel *)creatTaskModelToCommitTaskModel:(HQCreatTaskModel *)creatTaskModel;
//
//
//
//+ (HQCreatTaskModel *)commitTaskModelToCreatTaskModel:(HQCommitTaskModel *)commitTaskModel;
//
//
//+ (HQCreatTaskModel *)taskDetailModelToCreatTaskModel:(HQTaskDetailModel *)taskDetailModel;

//+ (HQCreatTaskModel *)projectStageModelToCreatTaskModel:(HQProjectStageModel *)projectStage;

@end
