//
//  TFApprovalItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@protocol TFApprovalItemModel
@end

@interface TFApprovalItemModel : HQBaseVoModel

/** taskId */
@property (nonatomic, strong) NSNumber <Optional>*taskId;

/** 审批标题 */
@property (nonatomic, copy) NSString <Optional>*approveTitle;

/** 审批生效时间 */
@property (nonatomic, strong) NSNumber <Optional>*approveEffectiveTime;

/** 审批时间 */
@property (nonatomic, strong) NSString <Optional>*approveTime;

/** 状态 0表示待审批，1表示已通过，2表示已撤销，3表示已驳回 */
@property (nonatomic, strong) NSNumber <Optional>*approveState;
/** 审批步骤 */
@property (nonatomic, strong) NSNumber <Optional>*approveStep;
@property (nonatomic, strong) NSNumber <Optional>*isReject;
@property (nonatomic, strong) NSNumber <Optional>*isCancel;

/** 类型id */
@property (nonatomic, strong) NSNumber <Optional>*approveTypeId;
/** 类型名 */
@property (nonatomic, copy) NSString <Optional>*approveTypeName;
/** 类型 */
@property (nonatomic, strong) NSNumber <Optional>*type;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;

/** 优先级 */
@property (nonatomic, strong) NSNumber <Optional>*howUrgency;

/** 文件数量 */
@property (nonatomic, strong) NSNumber <Optional>*attachmentCount;

/** 审批人id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 审批人 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 审批头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;

/** 审批人id */
@property (nonatomic, strong) NSNumber <Optional>*approverId;
/** 审批人 */
@property (nonatomic, copy) NSString <Optional>*approverName;
/** 审批头像 */
@property (nonatomic, copy) NSString <Optional>*approverPhotograph;


/** 用于工作台 */
@property (nonatomic, strong) NSNumber <Optional>*module;

/** 工资标准 */
@property (nonatomic, copy) NSString <Optional>*moneyLevel;
/** 现有人数 */
@property (nonatomic, copy) NSString <Optional>*nowNumber;
/** 招聘人数 */
@property (nonatomic, copy) NSString <Optional>*employNumber;


/** 人事调动时间 */
@property (nonatomic, strong) NSNumber <Optional>*personalDate;

/** 物品数量 */
@property (nonatomic, copy) NSString <Optional>*goodsNumber;
/** 物品用处 */
@property (nonatomic, copy) NSString <Optional>*goodsUse;
/** 物品名 */
@property (nonatomic, copy) NSString <Optional>*goodsName;


/** 报销金额 */
@property (nonatomic, strong) NSString <Optional>*reimbursementMoney;
/** 发生日期 */
@property (nonatomic, strong) NSNumber <Optional>*happenDate;
/** 报销类型 */
@property (nonatomic, copy) NSString <Optional>*reimbursementType;


/** 缺卡类型 0表示上班，1表示下班 */
@property (nonatomic, strong) NSNumber <Optional>*missCardType;
/** 缺卡日期 */
@property (nonatomic, strong) NSNumber <Optional>*missCardDate;


/** 地点 */
@property (nonatomic, copy) NSString <Optional>*placeDecription;
/** 理由说明 */
@property (nonatomic, copy) NSString <Optional>*reasonDescription;
/** 多少天 */
@property (nonatomic, copy) NSString <Optional>*howDay;

/** 建议反馈 */
@property (nonatomic, copy) NSString <Optional>*proposalStatement;



/** 开始时间 */
@property (nonatomic, strong) NSNumber <Optional>*startDate;
/** 结束时间 */
@property (nonatomic, strong) NSNumber <Optional>*endDate;

/** 用于移动 */
@property (nonatomic, strong) NSNumber<Optional> *inTime;


@end
