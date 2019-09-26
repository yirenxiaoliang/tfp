//
//  TFProjectDetailModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectItem.h"
#import "HQEmployModel.h"

@interface TFProjectDetailModel : JSONModel

/** project对象 */
@property (nonatomic, strong) TFProjectItem <Optional>*project;


/** principals */
@property (nonatomic, strong) NSArray <HQEmployModel,Optional>*participantEmpIds;

@end
