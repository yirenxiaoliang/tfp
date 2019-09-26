//
//  TFProjectFileListController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFProjectFileListController : HQBaseViewController

@property (nonatomic, copy) NSString *naviTitle;

@property (nonatomic, strong) NSNumber *dataId;

@property (nonatomic, strong) NSNumber *projectId;

//文件夹id
@property (nonatomic, strong) NSNumber *folderId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) ActionHandler refresh;

@end
