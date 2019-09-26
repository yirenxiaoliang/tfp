//
//  TFAuthAssignController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFAuthAssignController : HQBaseViewController

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, assign) NSInteger upload;

@property (nonatomic, assign) NSInteger download;

@property (nonatomic, strong) NSNumber *folderId;

@property (nonatomic, copy) ActionHandler refreshAction;

@end
