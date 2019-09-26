//
//  TFAddFolderController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAddFolderController : HQBaseViewController

@property (nonatomic, assign) NSInteger fileSeries;

@property (nonatomic, copy) NSString *labColor;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

//
@property (nonatomic, copy) NSString *parentId;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

@end
