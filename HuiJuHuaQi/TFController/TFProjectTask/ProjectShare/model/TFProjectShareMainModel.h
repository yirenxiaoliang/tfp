//
//  TFProjectShareMainModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFProjectShareInfoModel.h"
#import "TFPageInfoModel.h"

@interface TFProjectShareMainModel : JSONModel

@property (nonatomic, strong) NSArray <TFProjectShareInfoModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
