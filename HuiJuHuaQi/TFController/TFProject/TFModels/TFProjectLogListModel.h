//
//  TFProjectLogListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFTaskLogContentModel.h"

@interface TFProjectLogListModel : HQBaseListModel

@property (nonatomic, strong) NSArray <TFTaskLogContentModel,Optional>*list;

@end
