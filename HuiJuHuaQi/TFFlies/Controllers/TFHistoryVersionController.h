//
//  TFHistoryVersionController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFFolderListModel.h"

@interface TFHistoryVersionController : HQBaseViewController

/** 文件id */
@property (nonatomic, strong) NSNumber *fileId;

@property (nonatomic, strong) TFFolderListModel *model;

@property (nonatomic, strong) NSNumber *download;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

@end
