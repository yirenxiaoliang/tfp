//
//  TFTaskListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFTaskListController : HQBaseViewController

/** type 0:全部 1：我负责 2：我参与 3：我创建 4：进行中 5：已完成 */
@property (nonatomic, assign) NSInteger type;

@end
