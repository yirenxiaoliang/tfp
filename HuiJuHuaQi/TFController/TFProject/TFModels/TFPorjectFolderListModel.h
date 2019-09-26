//
//  TFPorjectFolderListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseListModel.h"
#import "TFProjectFolderItemModel.h"

@interface TFPorjectFolderListModel : HQBaseListModel

/** list */
@property (nonatomic, strong) NSArray <TFProjectFolderItemModel,Optional>*list;

@end
