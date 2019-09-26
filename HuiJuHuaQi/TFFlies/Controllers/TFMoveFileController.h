//
//  TFMoveFileController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFMoveFileController : HQBaseViewController

/** 0:移动 1:复制 2:转为公司文件 */
@property (nonatomic, assign) NSInteger type;

/** 要移动的文件夹id */
@property (nonatomic, strong) NSNumber *folderId;

@property (nonatomic, assign) NSInteger folderSeries;

@property (nonatomic,strong) NSMutableArray *pathArr;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSNumber *parentId;

@end
