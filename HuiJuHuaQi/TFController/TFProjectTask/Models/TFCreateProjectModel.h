//
//  TFCreateProjectModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQEmployModel.h"
#import "TFProjectClassModel.h"

@interface TFCreateProjectModel : NSObject

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 公开 0：不公开 1：公开 */
@property (nonatomic, assign) NSInteger visible;

/** 负责人 */
@property (nonatomic, strong) HQEmployModel *responsible;

/** 开始时间 */
@property (nonatomic, strong) NSNumber *startTime;

/** 截止时间 */
@property (nonatomic, strong) NSNumber *endTime;

/** 项目模板 */
@property (nonatomic, strong) TFProjectClassModel *projectModel;

/** 描述 */
@property (nonatomic, copy) NSString *descript;

/** 项目状态 （0进行中（启用） 1归档 2暂停 3删除 ）*/
@property (nonatomic, assign) NSInteger projectType;

/** 项目状态 */
@property (nonatomic, assign) NSInteger projectProgress;

/** 新建提交的数据 */
@property (nonatomic, strong) NSMutableDictionary *dict;

/** 项目进度Type */
@property (nonatomic, strong) NSNumber *project_progress_status;
/** 项目进度 */
@property (nonatomic, strong) NSNumber *project_progress_content;
/** 项目完成任务个数 */
@property (nonatomic, strong) NSNumber *task_complete_count;
/** 项目任务个数 */
@property (nonatomic, strong) NSNumber *task_count;
/** 项目自动计算进度 */
@property (nonatomic, strong) NSNumber *project_progress_number;

@end
