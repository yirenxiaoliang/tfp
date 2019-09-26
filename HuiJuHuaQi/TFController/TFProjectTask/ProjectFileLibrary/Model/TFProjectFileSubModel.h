//
//  TFProjectFileSubModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFProjectFileModel.h"

@interface TFProjectFileSubModel : JSONModel

@property (nonatomic, strong) NSMutableArray <TFProjectFileModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
