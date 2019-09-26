//
//  TFSearchPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSearchPeopleController : HQBaseViewController

/** isSelect */
@property (nonatomic, assign) BOOL isSee;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** 部门id */
@property (nonatomic, strong) NSNumber *departmentId;
@property (nonatomic, strong) NSNumber *dismiss;


@end
