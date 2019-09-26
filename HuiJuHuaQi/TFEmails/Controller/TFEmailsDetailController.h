//
//  TFEmailsDetailController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFEmailReceiveListModel.h"

@interface TFEmailsDetailController : HQBaseViewController

@property (nonatomic, strong) NSNumber *emailId;

@property (nonatomic, strong) NSNumber *boxId;

@property (nonatomic, strong) TFEmailReceiveListModel *model;

@property (nonatomic, copy) ActionHandler refresh;

@end
