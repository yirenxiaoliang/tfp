//
//  TFEmailsListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailReceiveListModel.h"
#import "TFPageInfoModel.h"

@interface TFEmailsListModel : JSONModel

@property (nonatomic, strong) NSMutableArray <TFEmailReceiveListModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
