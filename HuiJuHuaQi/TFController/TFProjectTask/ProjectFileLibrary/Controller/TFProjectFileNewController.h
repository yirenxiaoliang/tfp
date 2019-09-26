//
//  TFProjectFileNewController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectFileNewController : HQBaseViewController

/** 0 创建文件夹 1 创建子文件夹 */
@property (nonatomic, strong) NSNumber *subType;

@property (nonatomic, strong) NSNumber *parentId;

@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, copy) NSString *folderName;

@property (nonatomic, assign) BOOL isEdit;

//文件夹id
@property (nonatomic, strong) NSNumber *folderId;

@property (nonatomic, copy) ActionHandler refresh;

@property (nonatomic, copy) Action action;

@end
