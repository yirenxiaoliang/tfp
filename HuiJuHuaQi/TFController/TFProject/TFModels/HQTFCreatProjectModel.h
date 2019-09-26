//
//  HQTFCreatProjectModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectItem.h"

@interface HQTFCreatProjectModel : JSONModel


/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/**可见范围:0=私有;1=公开*/
@property (nonatomic, strong) NSNumber <Optional>*isPublic;

/** 项目标题 */
@property (nonatomic, copy) NSString <Optional>*projectName;

/** 项目描述 */
@property (nonatomic, copy) NSString <Optional>*descript;

/** 分类id */
@property (nonatomic, strong) NSNumber <Optional>*categoryId;
/** 分类名 */
@property (nonatomic, copy) NSString <Optional>*categoryName;

/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*endTime;

/** 负责人 */
@property (nonatomic, strong) NSMutableArray <Optional>*employeeIds;
/** 负责人 */
@property (nonatomic, strong) NSMutableArray <Optional>*employees;

/** 0不标星 1标星 */
@property (nonatomic, assign) NSInteger isMark;

/** 项目状态: 0=进行中(进行中，超期);1=已完成;2=暂停;3=已删除 */
@property (nonatomic, strong) NSNumber <Optional>*projectStatus;
/** 是否超期 */
@property (nonatomic, strong) NSNumber <Optional>*isOverdue;

/** 权限 0：没有权限 1：没有修改负责人的权限 2：所有权限 */
@property (nonatomic, strong) NSNumber <Optional>*permission;


/** 关联客户 */
@property (nonatomic, strong) NSNumber <Optional>*relateCustomer;

/** 关联项目 */
@property (nonatomic, strong) NSNumber <Optional>*relateProject;

/** 归属分类 */
@property (nonatomic, strong) NSNumber <Optional>*category;

/** 关注人 */
@property (nonatomic, strong) NSNumber <Optional>*focusPeople;

+ (HQTFCreatProjectModel *)changeProjectItemToCreatProjectModelWithProjectItem:(TFProjectItem *)projectItem;


@end
