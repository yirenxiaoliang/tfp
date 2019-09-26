//
//  TFTaskDynamicListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/3.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFTaskDynamicItemModel.h"
@interface TFTaskDynamicListModel : HQBaseListModel

/** 动态数组 */
@property (nonatomic, strong) NSArray <TFTaskDynamicItemModel,Optional>*list;


@end
