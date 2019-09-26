//
//  TFAgainMoveTaskController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAgainMoveTaskController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) TFProjectNodeModel *projectNode;
/** refreshAction */
@property (nonatomic, copy) ActionParameter refreshAction;
@end

NS_ASSUME_NONNULL_END
