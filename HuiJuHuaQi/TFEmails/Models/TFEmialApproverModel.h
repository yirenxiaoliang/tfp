//
//  TFEmialApproverModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailChoosePersonnelModel.h"

@interface TFEmialApproverModel : JSONModel

/** 0:固定流程 1:自由流程 */
@property (nonatomic, strong) NSNumber <Optional>*processType;

/** 角色对应的员工集合 */
@property (nonatomic, strong) NSArray <TFEmailChoosePersonnelModel,Optional>*choosePersonnel;

/** 0:显示抄送人 1:不显示抄送人 (选人范围：全公司) */
@property (nonatomic, strong) NSNumber <Optional>*ccTo;

@end
