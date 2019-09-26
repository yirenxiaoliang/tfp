//
//  TFProjectItem.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectPricipalModel.h"

@protocol TFProjectItem @end

@interface TFProjectItem : JSONModel


/** --------------------项目看板------------------------ */
/** 项目状态 */
@property (nonatomic, strong) NSNumber <Optional>*projectStatus;
/** 项目描述 */
@property (nonatomic, copy) NSString <Optional>*descript;
/** ？ */
@property (nonatomic, strong) NSNumber <Optional>*isHaveOrder;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*creatorId;
/** 公司id */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** 截止时间 */
@property (nonatomic, strong) NSNumber <Optional>*endTime;
/** 最新更新时间 */
@property (nonatomic, strong) NSNumber <Optional>*lastUpdateTime;
/** 参与人个数 */
@property (nonatomic, strong) NSNumber <Optional>*participantNumber;
/** 关联客户名字 */
@property (nonatomic, strong) NSString <Optional>*relatedCustomerName;
/** 可见范围 */
@property (nonatomic, strong) NSNumber <Optional>*isPublic;
/** 是否有文件 */
@property (nonatomic, strong) NSNumber <Optional>*isHaveFile;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createDate;
/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startTime;
/** 权限 0：没有权限 1：没有修改负责人的权限 2：所有权限 */
@property (nonatomic, strong) NSNumber <Optional>*permission;


/** --------------------项目列表------------------------ */
/** 项目分类id */
@property (nonatomic, strong) NSNumber <Optional>*categoryId;
/** 项目分类名 */
@property (nonatomic, strong) NSString <Optional>*categoryName;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/**项目收藏Id*/
@property (nonatomic, strong) NSNumber <Optional>*projectCollectId;
/**此项目是否超期:0=否;1=是*/
@property (nonatomic, strong) NSNumber <Optional>*isOverdue;
/**本人是此项目的负责人:0=否;1=是*/
@property (nonatomic, strong) NSNumber <Optional>*isPrincipal;
/** 项目任务完成数 */
@property (nonatomic, strong) NSNumber <Optional>*finishedTaskCount;
/** 项目任务总数 */
@property (nonatomic, strong) NSNumber <Optional>*taskCount ;
/** 项目名 */
@property (nonatomic, copy) NSString <Optional>*projectName;
/** 项目序列 */
@property (nonatomic, copy) NSString <Optional>*serialNumber;
/** 项目负责人列表 */
@property (nonatomic, strong) NSArray <Optional,TFProjectPricipalModel>*projectPrincipals;


@end
