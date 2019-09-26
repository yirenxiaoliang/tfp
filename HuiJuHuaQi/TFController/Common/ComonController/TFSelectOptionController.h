//
//  TFSelectOptionController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/8.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFCustomerOptionModel.h"

@interface TFSelectOptionController : HQBaseViewController

/** entrys */
@property (nonatomic, strong) NSArray *entrys;
/** 选中的 */
@property (nonatomic, strong) NSArray *selectEntrys;

/** selectType yes:单选 no：多选 */
@property (nonatomic, assign) BOOL isSingleSelect;

/** 是否还有下级（用于多级选择时判断是否还有下级） */
@property (nonatomic, assign) BOOL isMutil;

/** 值 */
@property (nonatomic, copy) ActionParameter selectAction;

/** 返回的控制器 */
@property (nonatomic, weak) UIViewController *backVc;

/** isTaskTag */
@property (nonatomic, assign) BOOL isTaskTag;
/** projectId */
@property (nonatomic, strong) NSNumber *projectId;


@end
