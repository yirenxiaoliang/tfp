//
//  TFQuoteTaskListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFQuoteTaskItemModel.h"

@interface TFQuoteTaskListModel : JSONModel

/** pageInfo */
@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

/** dataList */
@property (nonatomic, strong) NSArray <Optional,TFQuoteTaskItemModel>*dataList;


@end
