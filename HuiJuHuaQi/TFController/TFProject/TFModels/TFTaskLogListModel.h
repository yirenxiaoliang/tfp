//
//  TFTaskLogListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFTaskLogItemModel.h"

@interface TFTaskLogListModel : HQBaseListModel

@property (nonatomic, strong) NSArray <TFTaskLogItemModel,Optional>*list;

@end
