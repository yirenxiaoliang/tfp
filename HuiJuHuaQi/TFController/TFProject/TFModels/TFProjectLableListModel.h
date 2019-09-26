//
//  TFProjectLableListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseResponseModel.h"
#import "TFProjLabelModel.h"

@interface TFProjectLableListModel : HQBaseResponseModel

/** markLabels */
@property (nonatomic, strong) NSArray <Optional,TFProjLabelModel>*markLabels;
/** allLabels */
@property (nonatomic, strong) NSArray <Optional,TFProjLabelModel>*allLabels;


@end
