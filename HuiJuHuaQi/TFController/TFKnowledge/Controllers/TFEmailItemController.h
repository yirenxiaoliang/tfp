//
//  TFEmailItemController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFEmailItemController : HQBaseViewController
/** 0:收件箱 1：发件箱 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) ActionParameter numParameter;


@property (nonatomic, strong) NSMutableArray *selects;

@end

NS_ASSUME_NONNULL_END
