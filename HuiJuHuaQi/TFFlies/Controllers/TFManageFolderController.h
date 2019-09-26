//
//  TFManageFolderController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/26.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFManageFolderController : HQBaseViewController

@property (nonatomic, assign) NSInteger fileSeries;

@property (nonatomic, copy) NSString *labColor;

@property (nonatomic, strong) NSNumber *folderId;

@property (nonatomic, copy) NSString *folderName;

@property (nonatomic, copy) ActionHandler refreshAction;

@end
