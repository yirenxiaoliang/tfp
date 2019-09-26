//
//  TFProjectListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFProjectItem.h"
@interface TFProjectListModel : HQBaseListModel

/** 项目列表 */
@property (nonatomic, strong) NSArray <TFProjectItem,Optional>*list;


@end
