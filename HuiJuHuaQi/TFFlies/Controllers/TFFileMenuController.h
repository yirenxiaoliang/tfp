//
//  TFFileMenuController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFFileMenuController : HQBaseViewController

/** 文件库选进来 */
@property (nonatomic, assign) BOOL isFileLibraySelect;
/** 文件库层级 */
@property (nonatomic, assign) NSInteger series;

@property (nonatomic, copy) ActionParameter refreshAction;

@end
