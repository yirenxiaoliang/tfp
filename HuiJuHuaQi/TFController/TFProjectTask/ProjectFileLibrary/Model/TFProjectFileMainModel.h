//
//  TFProjectFileMainModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectFileProListModel.h"
#import "TFPageInfoModel.h"

@interface TFProjectFileMainModel : JSONModel

@property (nonatomic, strong) NSArray <TFProjectFileProListModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
