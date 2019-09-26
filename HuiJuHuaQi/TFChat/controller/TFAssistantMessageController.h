//
//  TFAssistantMessageController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAssistantMessageController : HQBaseViewController

@property (nonatomic, strong) NSMutableArray *assistantInfos;

@property (nonatomic, copy) ActionHandler refresh;

@end

NS_ASSUME_NONNULL_END
