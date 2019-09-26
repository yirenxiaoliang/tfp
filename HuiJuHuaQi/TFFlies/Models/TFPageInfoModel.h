//
//  TFPageInfoModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFPageInfoModel @end

@interface TFPageInfoModel : JSONModel

//{
//    "totalPages" : 1,
//    "totalRows" : 9,
//    "pageSize" : 30,
//    "curPageSize" : 9,
//    "pageNum" : 1
//}

@property (nonatomic, strong) NSNumber <Optional>*totalPages;

@property (nonatomic, strong) NSNumber <Optional>*totalRows;

@property (nonatomic, strong) NSNumber <Optional>*pageSize;

@property (nonatomic, strong) NSNumber <Optional>*curPageSize;

@property (nonatomic, strong) NSNumber <Optional>*pageNum;

@end
