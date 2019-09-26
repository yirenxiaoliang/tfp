//
//  TFProjectListItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"
#import "HQEmployModel.h"
@protocol TFProjectListItemModel @end

@interface TFProjectListItemModel : HQBaseVoModel

/** 关联客户id */
@property (nonatomic, strong) NSNumber <Optional>*relatedCustomerId;
/** 项目分类名 */
@property (nonatomic, copy) NSString <Optional>*listName;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*projectId;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*creatorId;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*orderStatus;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*listType;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*defaultUnite;
/** 描述 */
@property (nonatomic, copy) NSString <Optional>*descript;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*orderNumber;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*orderCategoryId;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startTime;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*productTotalSum;
/** 关联客户名 */
@property (nonatomic, copy) NSString <Optional>*relatedCustomerName;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*finishTaskNumber;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*taskNumber;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*productTotalDiscount;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*disabled;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*isLockTime;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*deadline;
/**  */
@property (nonatomic, strong) NSNumber <Optional>*isPublic;

/** 负责人列表 */
@property (nonatomic, strong) NSMutableArray <Optional,HQEmployModel>*managers;


@end
