//
//  TFCustomShareController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFCustomShareModel.h"

@interface TFCustomShareController : HQBaseViewController

/** dataId */
@property (nonatomic, strong) NSNumber *dataId;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** type 0:列表 1:新增 2：编辑 */
@property (nonatomic, assign) NSInteger type;

/** shareModel */
@property (nonatomic, strong) TFCustomShareModel *shareModel;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 删除 */
@property (nonatomic, copy) ActionHandler deleteAction;

@end
