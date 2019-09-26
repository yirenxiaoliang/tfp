//
//  TFEmailsNewController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFEmailReceiveListModel.h"

@interface TFEmailsNewController : HQBaseViewController

/** 0:新增 1:回复 2:转发 3:审批撤销 4:再次编辑 10:真真草稿 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) TFEmailReceiveListModel *detailModel;

@property (nonatomic, copy) ActionHandler refresh;

@end
