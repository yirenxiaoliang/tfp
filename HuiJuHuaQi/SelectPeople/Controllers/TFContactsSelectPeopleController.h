//
//  TFContactsSelectPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFContactsSelectPeopleController : HQBaseViewController

/** 主控制器的type 0:单一 ， 1：多个 */
@property (nonatomic, assign) NSInteger mainType;
/** type 0:子控制器 1：独立控制器*/
@property (nonatomic, assign) NSInteger type;

/** fourSelects */
@property (nonatomic, strong) NSMutableArray *fourSelects;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** actionParameter */
@property (nonatomic, copy) ActionParameter refresh;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** tableViewHeight */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;
@property (nonatomic, strong) NSNumber *dismiss;

@end
