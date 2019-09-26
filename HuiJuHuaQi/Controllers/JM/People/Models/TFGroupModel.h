//
//  TFGroupModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/5.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"
@interface TFGroupModel :HQBaseVoModel

/** 群名称 */
@property (nonatomic, copy) NSString *groupName;

/** 群描述 */
@property (nonatomic, copy) NSString *groupDesc;

/** 群颜色 */
@property (nonatomic, copy) NSString *groupColor;

/** 群人员*/
@property (nonatomic, strong) NSMutableArray *groupEmployees;

/** 群成员id */
@property (nonatomic, copy) NSString *groupEmployeeIds;

@end
