//
//  TFCustomRangePeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFCustomRangePeopleController : HQBaseViewController

/** 选中的人员 */
@property (nonatomic, strong) NSMutableArray *peoples;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;

/** 选择人员范围 */
@property (nonatomic, strong) NSArray *rangePeople;

/** 是不是部门 */
@property (nonatomic, assign) BOOL isDepartment;

@end
