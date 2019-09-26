//
//  TFSelectChatPersonController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFSelectChatPersonController : HQBaseViewController

/** 转发 */
@property (nonatomic, assign) BOOL isTrans;

/** 直接发送 */
@property (nonatomic, assign) BOOL isSend;

/** 多选 */
@property (nonatomic, assign) BOOL isSingle;

@property (nonatomic, assign) BOOL isSendFromFileLib;

/** 能不能选择群聊 */
@property(nonatomic, assign) BOOL haveGroup;

/** type 0:聊天 1：选人 */
@property (nonatomic, assign) NSInteger type;

/** 二次确认选人 */
@property (nonatomic, assign) BOOL isTwoSure;

/** 选择的人 */
@property (nonatomic, copy) ActionParameter actionParameter;
/** 自执行 */
@property (nonatomic, copy) ActionHandler action;

/** 其他模块发送文件到聊天 */
@property (nonatomic, strong) TFFileModel *fileModel;

@property (nonatomic, strong) TFFMDBModel *dbModel;

@end
