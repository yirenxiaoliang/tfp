//
//  TFFileProjectListController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFFileProjectListController : HQBaseViewController

/** 文件夹级数 */
@property (nonatomic, assign) NSInteger fileSeries;
@property (nonatomic, copy) NSString *naviTitle;

/** 文件导航路径数组 */
@property (nonatomic, strong) NSMutableArray *pathArr;

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, copy) NSString *library_type;

@property (nonatomic, strong) NSNumber *projectId;
/** 权限 */
@property (nonatomic, copy) NSString *privilege;

/** 刷新 */
@property (nonatomic, copy) ActionHandler refreshAction;

/** 文件库选进来 */
@property (nonatomic, assign) BOOL isFileLibraySelect;

/** 传值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@end
