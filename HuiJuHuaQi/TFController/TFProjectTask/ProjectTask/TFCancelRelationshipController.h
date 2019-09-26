//
//  TFCancelRelationshipController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectRowFrameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFCancelRelationshipController : HQBaseViewController


@property (nonatomic, strong) NSMutableArray *frames;

@property (nonatomic, copy) ActionHandler refreshAction;

@end

NS_ASSUME_NONNULL_END
