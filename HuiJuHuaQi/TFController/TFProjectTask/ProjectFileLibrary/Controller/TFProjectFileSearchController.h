//
//  TFProjectFileSearchController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectFileSearchController : HQBaseViewController

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

@property (nonatomic, assign) NSInteger style;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, strong) NSNumber *fileId;

@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, copy) NSString *libraryType;

@property (nonatomic, strong) NSNumber *projectId;
/** 文件库选进来 */
@property (nonatomic, assign) BOOL isFileLibraySelect;


@end
