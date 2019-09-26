//
//  TFProjectFileDetailController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFProjectFileModel.h"

@interface TFProjectFileDetailController : HQBaseViewController

@property (nonatomic, strong) TFProjectFileModel *fileModel;

@property (nonatomic, strong) NSNumber *projectId;

@property (nonatomic, assign) BOOL isFromChatRoom;

@end
