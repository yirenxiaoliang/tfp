//
//  HQTFChoicePeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectItem.h"


@interface HQTFChoicePeopleController : HQBaseViewController

/** peoject */
@property (nonatomic, strong) NSNumber *Id;
/** TFProjectSeeModel */
@property (nonatomic, strong) TFProjectItem *projectItem;


/** 选择的人员 */
@property (nonatomic, strong) NSArray *employees;


/** ChoicePeopleType */
@property (nonatomic, assign) ChoicePeopleType type;

/** 是否立刻push出新的控制器 */
@property (nonatomic, assign) BOOL instantPush;
/** 选择人员个数 NO：一个 Yes：多个 */
@property (nonatomic, assign) BOOL isMutual;

/** 值 */
@property (nonatomic, copy) ActionParameter actionParameter;

/** sectionTitle */
@property (nonatomic, copy) NSString *sectionTitle;
/** sectionTitle */
@property (nonatomic, copy) NSString *rowTitle;

@end
