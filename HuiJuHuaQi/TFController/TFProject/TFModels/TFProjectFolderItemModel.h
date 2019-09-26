//
//  TFProjectFolderItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseVoModel.h"

@protocol TFProjectFolderItemModel @end

@interface TFProjectFolderItemModel : HQBaseVoModel

/** 文件个数 */
@property (nonatomic, strong) NSNumber *fileNum;
/** 列表名称即文件夹名称 */
@property (nonatomic, strong) NSNumber *listName;


@end
