//
//  TFChooseRangePeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFDepartmentModel.h"

@interface TFChooseRangePeopleController : HQBaseViewController

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** 选中的东西 */
@property (nonatomic, strong) NSMutableArray *peoples;

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

/** 不可选中人员 */
@property (nonatomic, strong) NSArray *noSelectPoeples;

/** type 0：主级 1：次级*/
@property (nonatomic, assign) NSInteger type;


@end
