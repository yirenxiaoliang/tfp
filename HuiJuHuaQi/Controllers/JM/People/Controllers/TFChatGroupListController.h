//
//  TFChatGroupListController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFChatGroupListController : HQBaseViewController

/** 其他模块发送文件到聊天 */
@property (nonatomic, strong) TFFileModel *fileModel;
@property (nonatomic, strong) TFFMDBModel *dbModel;

@property (nonatomic, assign) BOOL isSendFromFileLib;

@property (nonatomic, assign) BOOL isTransitive;

@end
