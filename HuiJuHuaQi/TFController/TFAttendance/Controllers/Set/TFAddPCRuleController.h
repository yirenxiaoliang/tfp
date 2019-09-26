//
//  TFAddPCRuleController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAddPCRuleController : HQBaseViewController

@property (nonatomic, copy) NSString *atdName;

@property (nonatomic, strong) NSMutableArray *atdPersons;

@property (nonatomic, strong) NSMutableArray *noAtdPersons;
/** 0:新增 1:编辑 */
@property (nonatomic, assign) NSInteger vcType;
/** 详情字典 */
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSNumber *id;
/** 考勤类型，0:固定班次，1排班制，2：自由打卡 */ 
@property (nonatomic,assign) NSInteger type;

@end
