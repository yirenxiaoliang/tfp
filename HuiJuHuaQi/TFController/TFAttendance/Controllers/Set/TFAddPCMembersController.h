//
//  TFAddPCMembersController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAddPCMembersController : HQBaseViewController

/** 0:新增 1：修改 */
@property (nonatomic, assign) NSInteger vcType;
/** 详情字典 */
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, copy) NSString *atdName;

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, strong) NSMutableArray <HQEmployModel,Optional>*atdPersons;

@property (nonatomic, strong) NSMutableArray <HQEmployModel,Optional>*noAtdPersons;


@end
