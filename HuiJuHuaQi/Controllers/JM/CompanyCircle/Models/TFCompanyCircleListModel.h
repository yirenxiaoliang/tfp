//
//  TFCompanyCircleListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "HQCategoryItemModel.h"

@interface TFCompanyCircleListModel : HQBaseListModel

/** list */
@property (nonatomic, strong) NSArray <HQCategoryItemModel,Optional>*list;

@end
