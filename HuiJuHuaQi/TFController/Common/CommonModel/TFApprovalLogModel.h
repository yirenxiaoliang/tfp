//
//  TFApprovalLogModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/5/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@protocol TFApprovalLogModel

@end

@interface TFApprovalLogModel : HQBaseVoModel

/** 头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;

/** employeeName */
@property (nonatomic, copy) NSString <Optional>*employeeName;

/** approveId */
@property (nonatomic, copy) NSNumber <Optional>*approveId;

/** createTime */
@property (nonatomic, copy) NSNumber <Optional>*createTime;

/** approveId */
@property (nonatomic, copy) NSNumber <Optional>*employeeId;

/** operationContent */
@property (nonatomic, copy) NSString <Optional>*operationContent;


@end
