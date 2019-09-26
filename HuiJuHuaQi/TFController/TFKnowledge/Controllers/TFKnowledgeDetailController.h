//
//  TFKnowledgeDetailController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFKnowledgeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFKnowledgeDetailController : HQBaseViewController

/** 数据ID */
@property (nonatomic, strong) NSNumber *dataId;
/** 是否为回答 */
@property (nonatomic, assign) BOOL answer;
/** 详情 */
@property (nonatomic, strong) TFKnowledgeItemModel *knowledgeDetail;
/** 刷新 */
@property (nonatomic, copy) ActionHandler deleteAction;
/** 编辑和移动等刷新 */
@property (nonatomic, copy) ActionParameter refreshAction;
/** 重新加载数据 */
@property (nonatomic, copy) ActionParameter reloadAction;

@end

NS_ASSUME_NONNULL_END
