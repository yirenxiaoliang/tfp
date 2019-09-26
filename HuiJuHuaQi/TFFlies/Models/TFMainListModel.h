//
//  TFMainListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFFolderListModel.h"

@interface TFMainListModel : JSONModel

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@property (nonatomic, strong) NSMutableArray <TFFolderListModel,Optional>*dataList;

@end
