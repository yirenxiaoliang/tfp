//
//  TFProjectFileTypeController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectFileTypeController : HQBaseViewController

@property (nonatomic, copy) NSString *naviTitle;

/** type 0:全部 1：文档 2：图片 3：音频4：视频 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, copy) NSString *libraryType;

@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, strong) NSNumber *folderId;
@property (nonatomic, copy) ActionHandler refresh;
/** 权限 */
@property (nonatomic, copy) NSString *privilege;

@end
