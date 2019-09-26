//
//  TFCustomSearchController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFCustomAuthModel.h"

@interface TFCustomSearchController : HQBaseViewController

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** keyName */
@property (nonatomic, copy) NSString *keyLabel;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** isSeasAdmin 是否为公海池管理员 0：非 1：是 */
@property (nonatomic, copy) NSString *isSeasAdmin;
/** isSeasPool 是否为公海池 0：非 1：是 */
@property (nonatomic, copy) NSString *isSeasPool;
/** 公海池id */
@property (nonatomic, strong) NSNumber *seaPoolId;
/** customer */
@property (nonatomic, strong) NSNumber *beanType;
/** 菜单类型 */
@property (nonatomic, copy) NSString *menuType;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

/** searchType 0：列表搜索 1：新增查重 */
@property (nonatomic, assign) NSInteger searchType;


@property (nonatomic, strong) TFCustomAuthModel *auth;
/** processId */
@property (nonatomic, copy) NSString *processId;
@property (nonatomic, strong) NSNumber *dataId;

@end
