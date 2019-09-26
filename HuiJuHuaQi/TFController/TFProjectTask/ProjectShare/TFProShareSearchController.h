//
//  TFProShareSearchController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProShareSearchController : HQBaseViewController

@property (nonatomic, strong) NSNumber *projectId;

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, copy) gradeAction refresh;

@end
