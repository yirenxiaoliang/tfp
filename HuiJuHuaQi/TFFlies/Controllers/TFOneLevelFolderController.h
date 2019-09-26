//
//  TFOneLevelFolderController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFOneLevelFolderController : HQBaseViewController

@property (nonatomic, copy) NSString *naviTitle;

/** 文件夹级数 */
@property (nonatomic, assign) NSInteger fileSeries;

/** 文件导航路径数组 */
@property (nonatomic, strong) NSMutableArray *pathArr;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

/** 父文件夹id */
@property (nonatomic, strong) NSNumber *parentId;

/** 父文件夹url */
@property (nonatomic, copy) NSString *parentUrl;

/** 搜索进来 */
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSNumber *presentId;

/** 是否是管理员 0:不是 1:是 */
@property (nonatomic, assign) NSInteger isManager;

/** 是否有上传权限 0:没有 1:有 */
@property (nonatomic, assign) NSInteger canUpload;

/** 共享跟与我共享用 */
@property (nonatomic, assign) NSInteger shareStyle;

@property (nonatomic, strong) NSNumber *modelId;

@property (nonatomic, strong) NSNumber *shareFileId;

/** 文件库选进来 */
@property (nonatomic, assign) BOOL isFileLibraySelect;

/** 回调 */
@property (nonatomic, copy) ActionParameter refreshAction;

@end
