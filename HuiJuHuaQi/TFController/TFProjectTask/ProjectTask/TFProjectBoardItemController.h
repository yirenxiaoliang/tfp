//
//  TFProjectBoardItemController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectColumnModel.h"
#import "TFProjectModel.h"

@interface TFProjectBoardItemController : HQBaseViewController

/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sections */
@property (nonatomic, strong) TFProjectColumnModel *projectColumnModel;

/** indexAction */
@property (nonatomic, copy) ActionParameter indexAction;

/** refreshAction */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 用于刷新该控制器boardView数据 */
-(void)refreshBoardViewData;


@property (nonatomic, strong) TFProjectModel *projectModel;

@end
