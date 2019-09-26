//
//  TFAttendenceFieldController.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFAttendenceFieldModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFAttendenceFieldController : HQBaseViewController

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) TFAttendenceFieldModel *field;

@property (nonatomic, copy) ActionParameter action;

@end

NS_ASSUME_NONNULL_END
