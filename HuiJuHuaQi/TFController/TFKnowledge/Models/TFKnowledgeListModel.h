//
//  TFKnowledgeListModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFKnowledgeItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFKnowledgeListModel : JSONModel


@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@property (nonatomic, strong) NSArray <TFKnowledgeItemModel,Optional>*dataList;
@end

NS_ASSUME_NONNULL_END
