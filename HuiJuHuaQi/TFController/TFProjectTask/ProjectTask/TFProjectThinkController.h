//
//  TFProjectThinkController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFProjectThinkController : HQBaseViewController
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, strong) TFProjectModel *projectModel;

@end

NS_ASSUME_NONNULL_END
