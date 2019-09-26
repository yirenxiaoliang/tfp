//
//  TFTransferTaskController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectPeopleModel.h"


@interface TFTransferTaskController : HQBaseViewController

/** 选中删除的人 */
@property (nonatomic, strong) TFProjectPeopleModel *deletePeople;

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** deleteAction */
@property (nonatomic, copy) ActionHandler deleteAction;

@end
