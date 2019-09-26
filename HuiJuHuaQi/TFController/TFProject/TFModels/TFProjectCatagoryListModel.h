//
//  TFProjectCatagoryListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFProjectCatagoryItemModel.h"

@interface TFProjectCatagoryListModel : HQBaseListModel

/** 项目列表 */
@property (nonatomic, strong) NSArray <TFProjectCatagoryItemModel,Optional>*list;

@end
