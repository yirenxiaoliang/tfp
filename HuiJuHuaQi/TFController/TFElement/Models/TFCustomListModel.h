//
//  TFCustomListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomPageModel.h"
#import "TFCustomListItemModel.h" 

@interface TFCustomListModel : JSONModel

/** 页 */
@property (nonatomic, strong) TFCustomPageModel <Optional>*pageInfo;
/** 搜索字段 */
@property (nonatomic, strong) TFFieldNameModel <Optional>*operationInfo;
/** 隐藏字段 */
@property (nonatomic, strong) NSString <Optional>*seasPwdFields;

/** 数据 */
@property (nonatomic, strong) NSArray <Optional,TFCustomListItemModel>*dataList;


@end
