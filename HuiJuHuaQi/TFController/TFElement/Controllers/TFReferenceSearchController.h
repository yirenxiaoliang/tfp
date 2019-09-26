//
//  TFReferenceSearchController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFReferenceSearchController : HQBaseViewController

/** 搜索字段 */
@property (nonatomic, copy) NSString *searchField;
/** 搜索字段Id */
@property (nonatomic, assign) NSInteger searchFieldId;

/** 当前布局表单数据 */
@property (nonatomic, strong) NSMutableDictionary *from;
/** 依赖字段 */
@property (nonatomic, strong) NSMutableDictionary *reylonForm;

/** 所在的bean */
@property (nonatomic, copy) NSString *bean;
/** 所在的bean */
@property (nonatomic, copy) NSString *subform;

/** 需搜索关联的bean */
//@property (nonatomic, copy) NSString *referBean;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

/** 能否多选 */
@property (nonatomic, assign) BOOL isMulti;

/** 0:关联关系  1:子表关联 */
@property (nonatomic, assign) NSInteger type;

@end
