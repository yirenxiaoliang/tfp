//
//  TFCustomTransferController.h
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCustomTransferController : HQBaseViewController

/** bean */
@property (nonatomic, copy) NSString *bean;

/** dataId */
@property (nonatomic, strong) NSNumber *dataId;

/** 数据的负责人 */
@property (nonatomic, strong) NSDictionary *principal;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
