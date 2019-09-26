//
//  TFProjectTaskListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectListItemModel.h"
#import "TFTaskPageVoModel.h"
#import "HQEmployModel.h"

@protocol TFProjectTaskListModel 
@end

@interface TFProjectTaskListModel : JSONModel

/** projTaskList */
@property (nonatomic, strong)  TFProjectListItemModel <Optional>*projTaskList;


/** taskPageVo */
@property (nonatomic, strong)  TFTaskPageVoModel <Optional>*taskPageVo;

/** 参与人列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*managers;

@end
