//
//  TFThinkPreviewController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/20.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFThinkPreviewController : HQBaseViewController

/** templateId */
@property (nonatomic, strong) NSNumber *templateId;

/** sureAction */
@property (nonatomic, copy) ActionHandler sureAction;

@end

NS_ASSUME_NONNULL_END
