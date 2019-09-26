//
//  TFCreateKnowledgeController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFCreateKnowledgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFCreateKnowledgeController : HQBaseViewController

/** type 0:新建 1:编辑 */
@property (nonatomic, assign) NSInteger edit;
/** 知识类型 0：新增 1：提问 2：回答 */
@property (nonatomic, assign) NSInteger type;
/** parentId  */
@property (nonatomic, strong) NSNumber *parentId;
/** dataId  */
@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, strong) TFCreateKnowledgeModel *knowledge;

@property (nonatomic, copy) ActionHandler refresh;
@end

NS_ASSUME_NONNULL_END
