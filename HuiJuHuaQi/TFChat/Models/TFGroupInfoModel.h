//
//  TFGroupInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFChatInfoListModel.h"
#import "TFGroupEmployeeModel.h"

@interface TFGroupInfoModel : JSONModel

@property (nonatomic, strong) NSMutableArray <TFGroupEmployeeModel,Optional>*employeeInfo;

@property (nonatomic, strong) TFChatInfoListModel <Optional>*groupInfo;

@end
