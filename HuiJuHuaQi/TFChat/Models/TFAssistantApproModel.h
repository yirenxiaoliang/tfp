//
//  TFAssistantApproModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFAssistantApproModel @end

@interface TFAssistantApproModel : JSONModel

//       [self.customBL requestQueryApprovalDataWithDataId:[dic valueForKey:@"dataId"] type:[dic valueForKey:@"fromType"] bean:[dic valueForKey:@"moduleBean"] processInstanceId:[dic valueForKey:@"processInstanceId"]];

@property (nonatomic, strong) NSNumber <Optional>*dataId;

@property (nonatomic, strong) NSNumber <Optional>*fromType;

@property (nonatomic, copy) NSString <Optional>*moduleBean;

@property (nonatomic, copy) NSString <Optional>*taskKey;

@property (nonatomic, copy) NSString <Optional>*processInstanceId;

//"{"
//data_Type ":2,"
//sub_id ":227,"
//taskInfoId ":559,"
//beanName ":"
//project_custom_32 ","
//taskName ":"
//BUG9527 "}"

//项目、任务
@property (nonatomic, strong) NSNumber <Optional>*data_Type;
@property (nonatomic, strong) NSNumber <Optional>*task_id;
@property (nonatomic, strong) NSNumber <Optional>*task_type;
@property (nonatomic, strong) NSNumber <Optional>*projectId;
@property (nonatomic, copy) NSString <Optional>*beanName;
@property (nonatomic, copy) NSString <Optional>*taskName;
@property (nonatomic, strong) NSNumber <Optional>*taskInfoId;
@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, strong) NSNumber <Optional>*from;


@end
