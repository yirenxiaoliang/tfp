//
//  HQDepartmentModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"
#import "HQBaseVoModel.h"

@protocol HQDepartmentModel @end

@interface HQDepartmentModel : HQBaseVoModel


/** 部门名 */
@property (nonatomic, copy) NSString <Optional>*departmentName;
/** 父部门id */
@property (nonatomic, strong) NSNumber <Optional>*parentDepartmentId;
/** 负责人id */
@property (nonatomic, strong) NSNumber <Optional>*principalId;
/** 默认 */
@property (nonatomic, strong) NSNumber <Optional>*isDefault;
/** 可用 */
@property (nonatomic, strong) NSNumber <Optional>*disabled;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 部门人数 */
@property (nonatomic, strong) NSNumber <Optional>*count;


/** 收缩 "YES"为收缩 "NO"为展开 */
@property (nonatomic, copy) NSString <Ignore>*isShrink;
/** 层次 */
@property (nonatomic, strong) NSNumber <Ignore>*levelNum;
/** 排序 */
@property (nonatomic, strong) NSNumber <Ignore>*order;

/** 员工列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*employees;

/** 子部门列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQDepartmentModel>*departments;



/** 企业成员中展开状态 */
@property (nonatomic, strong) NSNumber <Ignore>*open;
/** 选择部门选中状态 @1 为选中， @0 为未选中 */
@property (nonatomic, strong) NSNumber <Ignore>*isSelect;

@end
