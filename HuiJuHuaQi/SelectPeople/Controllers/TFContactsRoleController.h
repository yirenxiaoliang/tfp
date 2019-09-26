//
//  TFContactsRoleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFDepartmentModel.h"
#import "TFRoleModel.h"

@interface TFContactsRoleController : HQBaseViewController

/** 主控制器的type */
@property (nonatomic, assign) NSInteger mainType;
/** type 0:次级页面 1：主界面 */
@property (nonatomic, assign) NSInteger type;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** 选中的东西 */
@property (nonatomic, strong) NSMutableArray *fourSelects;


/** paths */
@property (nonatomic, strong) NSMutableArray *paths;


/** TFDepartmentModel */
@property (nonatomic, strong) TFRoleModel *department;

/** 公司组织架构 */
@property (nonatomic, strong) NSArray *companyFrameWorks;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** tableViewHeight */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 单独使用 */
@property (nonatomic, assign) BOOL isSingleUse;

@end
