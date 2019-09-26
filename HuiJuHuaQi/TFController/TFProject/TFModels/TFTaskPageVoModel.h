//
//  TFTaskPageVoModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFProjTaskModel.h"

@protocol TFTaskPageVoModel
@end

@interface TFTaskPageVoModel : HQBaseListModel

/** list */
@property (nonatomic, strong) NSArray <TFProjTaskModel,Optional>*list;



@end
