//
//  TFSelectStatusController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/29.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectRowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFSelectStatusController : HQBaseViewController

@property (nonatomic, strong) NSArray *options;
/** 0 : 状态 ，1：优先级 , 2：进行切换状态 */
@property (nonatomic, assign) NSInteger type;
/** 选择 */
@property (nonatomic, copy) ActionParameter sureHandler;
/** 任务 */
@property (nonatomic, strong) TFProjectRowModel *task;
/** 刷新状态 */
@property (nonatomic, copy) ActionHandler refresh;

@end

NS_ASSUME_NONNULL_END
