//
//  TFContactsWorkFrameController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFDepartmentModel.h"

@interface TFContactsWorkFrameController : HQBaseViewController


/** 选中的东西 */
@property (nonatomic, strong) NSMutableArray *fourSelects;


/** paths */
@property (nonatomic, strong) NSMutableArray *paths;


/** TFDepartmentModel */
@property (nonatomic, strong) TFDepartmentModel *department;

/** 公司组织架构 */
@property (nonatomic, strong) NSArray *companyFrameWorks;

/** actionParameter */
@property (nonatomic, copy) ActionParameter actionParameter;

/** isSingleSelect 是否单选 NO:默认为多选 YES:单选  */
@property (nonatomic, assign) BOOL isSingleSelect;

/** 是否为查看 */
@property (nonatomic, assign) BOOL isSee;

/** 是否为主部门 */
@property (nonatomic, assign) BOOL isMianDepartment;

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;

@property (nonatomic, strong) NSNumber *dismiss;


@end
