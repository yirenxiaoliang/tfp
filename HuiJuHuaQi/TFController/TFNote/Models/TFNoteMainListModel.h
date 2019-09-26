//
//  TFMainListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFNoteDataListModel.h"

@interface TFNoteMainListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <TFNoteDataListModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
