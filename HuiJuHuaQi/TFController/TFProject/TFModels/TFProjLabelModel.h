//
//  TFProjLabelModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjLabelModel @end

@interface TFProjLabelModel : JSONModel

/** 任务id */
@property (nonatomic, strong) NSNumber<Optional> *taskId;
/** 项目id */
@property (nonatomic, strong) NSNumber<Optional> *projectId;
/** 标签id */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** 标签id */
@property (nonatomic, strong) NSNumber<Optional> *labelId;

/** 创建者id */
@property (nonatomic, strong) NSNumber<Optional> *creatorId;
/** 标签颜色 */
@property (nonatomic, copy) NSString<Optional> *labelColor;
/** 标签名字 */
@property (nonatomic, copy) NSString<Optional> *labelName;
/** 创建时间 */
@property (nonatomic, strong) NSNumber<Optional> *createDate;
/** 标签状态:0=正常;1=作废;2=常用*/
@property (nonatomic, strong) NSNumber<Optional> *labelStatus;


/** 用于选择 */
@property (nonatomic, assign) NSNumber<Ignore> *select;



@end
