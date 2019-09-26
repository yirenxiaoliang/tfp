//
//  TFAssistantMainModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFAssistListModel.h"

@interface TFAssistantMainModel : JSONModel

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@property (nonatomic, strong) NSArray <TFAssistListModel,Optional>*dataList;

@end
