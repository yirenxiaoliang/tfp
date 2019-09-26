//
//  TFNewTaskListController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFNewTaskListController : HQBaseViewController

/** type 0:全部 1：我负责 2：我参与 3：我创建 4：进行中 5：已完成 */
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
