//
//  TFProjectListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomPageModel.h"
#import "TFProjectModel.h"

@interface TFProjectListModel : JSONModel


/** 页 */
@property (nonatomic, strong) TFCustomPageModel <Optional>*pageInfo;

/** 数据 */
@property (nonatomic, strong) NSArray <Optional,TFProjectModel>*dataList;


@end
