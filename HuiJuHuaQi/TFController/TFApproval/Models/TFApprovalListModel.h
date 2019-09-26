//
//  TFApprovalListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomPageModel.h"
#import "TFApprovalListItemModel.h"

@interface TFApprovalListModel : JSONModel


/** 页 */
@property (nonatomic, strong) TFCustomPageModel <Optional>*pageInfo;

/** 数据 */
@property (nonatomic, strong) NSArray <Optional,TFApprovalListItemModel>*dataList;


@end
