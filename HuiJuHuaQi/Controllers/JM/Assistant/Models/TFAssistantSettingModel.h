//
//  TFAssistantSettingModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAssistantSettingModel : JSONModel

/** itemId */
@property (nonatomic, strong) NSNumber <Optional>*itemId;
/** employeeId */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** companyId */
@property (nonatomic, strong) NSNumber <Optional>*companyId;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** assiatRead */
@property (nonatomic, strong) NSNumber <Optional>*assiatRead;
/** createTime */
@property (nonatomic, strong) NSNumber <Optional>*createTime;
/** updateTime */
@property (nonatomic, strong) NSNumber <Optional>*updateTime;
/** createDate */
@property (nonatomic, strong) NSNumber <Optional>*createDate;
/** assiatNotice */
@property (nonatomic, strong) NSNumber <Optional>*assiatNotice;
/** disabled */
@property (nonatomic, strong) NSNumber <Optional>*disabled;
/** itemType */
@property (nonatomic, strong) NSNumber <Optional>*itemType;


@end
