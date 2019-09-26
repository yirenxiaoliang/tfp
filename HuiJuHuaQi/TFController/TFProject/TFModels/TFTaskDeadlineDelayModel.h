//
//  TFTaskDeadlineDelayModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"
#import "HQEmployModel.h"

@interface TFTaskDeadlineDelayModel :HQBaseVoModel

/** 申请的类型：0其他，1延时申请，2调班申请 */
@property (nonatomic, strong) NSNumber <Optional>*approvalType;
/** 申请到某时间 */
//@property (nonatomic, strong) NSNumber <Optional>*applyTime;
/** 核审人 */
@property (nonatomic, strong) NSNumber <Optional>*approverId;
/** 申请人id */
@property (nonatomic, strong) NSNumber <Optional>*applierId;
/** 所属任务 */
@property (nonatomic, strong) NSNumber <Optional>*taskId;
/** 申请人备注 */
@property (nonatomic, copy) NSString <Optional>*applierMark;
/** 核审人处理的结果：0未处理1同意2驳回3转发 */
@property (nonatomic, strong) NSNumber <Optional>*approvalResult;
/** 任务编号 */
@property (nonatomic, strong) NSNumber <Optional>*serialNumber;
/** 截至时间类型默认0时间点 1分钟 2小时 3天 4周 5月 6年7秒 */
@property (nonatomic, strong) NSNumber <Optional>*deadlineType ;
/** 任务的截止时间 */
@property (nonatomic, strong) NSNumber <Optional>*deadline;
/** 任务内容 */
@property (nonatomic, copy) NSString <Optional>*content;
/** 员工名字 */
@property (nonatomic, copy) NSString <Optional>*employeeName;


/** 审批人s */
@property (nonatomic, copy) NSMutableArray <HQEmployModel,Optional>*employees;


@end
